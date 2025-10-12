//
//  AppLogger.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 11.10.2025.
//

import Foundation
import os.log
import UIKit

let logger = AppLogger()

protocol LoggerProtocol {
    func debug(_ message: String)
    func info(_ message: String)
    func error(_ message: String)
}


final class AppLogger: LoggerProtocol {
    private static var general = OSLog(subsystem: "com.test.Animals", category: "general")
    
    func debug(_ message: String) {
        log(message, type: .debug)
    }
    
    func info(_ message: String) {
        log(message, type: .info)
    }
    
    func error(_ message: String) {
        log(message, type: .error)
    }
    
    private func log(_ message: String, type: LogType = .debug) {
            os_log("%{public}@: %{public}@", log: Self.general, type: type.osLogType, type.rawValue, message)
    }
}

extension AppLogger {
    enum LogType: String {
        case debug = "DEBUG"
        case info = "INFO"
        case error = "ERROR"
        
        var osLogType: OSLogType {
            switch self {
            case .debug:
                return .error
            case .info:
                return .default
            case .error:
                return .fault
            }
        }
    }
}
