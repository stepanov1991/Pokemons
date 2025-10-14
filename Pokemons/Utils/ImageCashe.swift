//
//  ImageCashe.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 14.10.2025.
//

import UIKit
import Combine

final class ImageCache {
    static let shared = ImageCache()

    private let maxCacheSize = 20
    private var cache = NSCache<NSString, UIImage>()
    private var accessOrder: [String] = []

    // Queue for background image loading tasks
    private let queue = DispatchQueue(label: "com.pokemon.imagecache.queue", attributes: .concurrent)

    private init() {
        cache.countLimit = maxCacheSize
    }

    func image(for urlString: String) -> AnyPublisher<UIImage?, Never> {
        let cacheKey = NSString(string: urlString)

        // Check if the image is already cached
        if let cachedImage = cache.object(forKey: cacheKey) {
            updateAccessOrder(for: urlString)
            return Just(cachedImage).eraseToAnyPublisher()
        }

        // If not in cache, download from the network
        guard let url = URL(string: urlString) else {
            return Just(nil).eraseToAnyPublisher()
        }

        let subject = PassthroughSubject<UIImage?, Never>()

        // Download the image asynchronously in the background
        queue.async { [weak self] in
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let self = self, error == nil, let data = data, let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        subject.send(nil)
                    }
                    return
                }

                // Cache the downloaded image
                self.cacheImage(image, forKey: urlString)

                // Send the image to the subject on the main thread
                DispatchQueue.main.async {
                    subject.send(image)
                    subject.send(completion: .finished)
                }
            }.resume()
        }

        return subject.eraseToAnyPublisher()
    }

    // Cache the image in memory
    private func cacheImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
        updateAccessOrder(for: key)
    }

    // Update the access order for Least Recently Used cache eviction
    private func updateAccessOrder(for urlString: String) {
        // Update access order: move the accessed item to the end
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }

            // If the image is already in the access order, remove it and re-add it at the end
            if let index = self.accessOrder.firstIndex(of: urlString) {
                self.accessOrder.remove(at: index)
            }
            self.accessOrder.append(urlString)

            // If the cache exceeds the maximum size, remove the oldest item
            if self.accessOrder.count > self.maxCacheSize {
                if let oldestKey = self.accessOrder.first {
                    self.accessOrder.removeFirst()
                    self.cache.removeObject(forKey: NSString(string: oldestKey))
                }
            }
        }
    }
}
