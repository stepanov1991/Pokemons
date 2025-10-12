//
//  RequestManager.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 11.10.2025.
//

import Foundation
import Combine

class RequestManager {
    
    static func request<T: Codable>(_ endpoint: Endpoint, resultType type: T.Type) -> AnyPublisher<T, AppError> {
        guard let url = endpoint.url else {
            return Fail(error: AppError.invalidRequestData).eraseToAnyPublisher()
        }
        
        logger.debug("Request URL: \(url.absoluteString)")
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    logger.error("No response")
                    throw AppError.somethingWentWrong
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    logger.error("Server returned status code: \(httpResponse.statusCode)")
                    throw AppError.somethingWentWrong
                }
                guard !data.isEmpty else {
                    logger.error("Data is empty")
                    throw AppError.emptyData
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder.default)
            .mapError { error -> AppError in
                switch error {
                case let decodingError as DecodingError:
                    logger.error("Parsing error: \(decodingError.localizedDescription)")
                    return AppError.parsingError(decodingError)
                case let urlError as URLError:
                    logger.error("Network error: \(urlError.localizedDescription)")
                    return AppError.networkError(urlError)
                case let appError as AppError:
                    return appError
                default:
                    logger.error("Unexpected error: \(error.localizedDescription)")
                    return AppError.somethingWentWrong
                }
            }
            .eraseToAnyPublisher()
    }
}

extension JSONDecoder {
    static let `default`: JSONDecoder  = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}

