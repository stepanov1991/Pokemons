//
//  AppError.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 11.10.2025.
//

import Foundation

enum AppError: Error {
    case invalidRequestData
    case somethingWentWrong
    case emptyData
    case parsingError(Error)
    case noAlarmStatusUpdatesInPush
    case networkError(Error?)
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidRequestData:
            return "Invalid request data"
        case .somethingWentWrong:
            return "Oops! Something Went Wrong."
        case .emptyData:
            return "Empty Data"
        case .parsingError(let error):
            return "Parsing error: \(error.localizedDescription)"
        case .noAlarmStatusUpdatesInPush:
            return "No alarm updates in push"
        case .networkError(let error):
            return error?.localizedDescription ?? ""
        }
    }
}

extension AppError: Equatable {
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        return switch (lhs, rhs) {
        case (.invalidRequestData, .invalidRequestData):
            true
        case (.somethingWentWrong, .somethingWentWrong):
            true
        case (.emptyData, .emptyData):
            true
        case (.parsingError(let error1), .parsingError(let error2)):
            error1._code == error2._code && error1.localizedDescription == error2.localizedDescription
        case (.noAlarmStatusUpdatesInPush, .noAlarmStatusUpdatesInPush):
            true
        case (.networkError(let error1), .networkError(let error2)):
            error1?._code == error2?._code && error1?.localizedDescription == error2?.localizedDescription
        default:
            false
        }
    }
}
