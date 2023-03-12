//
//  NewsAppErrors.swift
//  News
//
//  Created by Moin Uddin on 7/3/2023.
//

import Foundation

enum NewsAppError: Error, LocalizedError {
    case missingCredentials
    case noData
    case urlError(URLError)
    case responseError(Int)
    case decodingError(DecodingError)
    case genericError
    case unknown
    case apiError(reason: String)
    case parserError(reason: String)
    case networkError(from: Error)
    case noInternet
    case badImage

    var localizedDescription: String {
        switch self {
        case .missingCredentials:
            return "Missing credentials"
        case .noData:
            return "No data received"
        case .urlError(let error):
            return error.localizedDescription
        case .decodingError(let error):
            return error.localizedDescription
        case .responseError(let status):
            return "Bad response code: \(status)"
        case .genericError:
            return "An unknown error has been occured"
        case .unknown:
            return "Unknown error"
        case .apiError(let reason), .parserError(let reason):
            return reason
        case .networkError(let from):
            return from.localizedDescription
        case .noInternet:
            return "The app requires internent connectivity to download and display news feed."
        case .badImage:
            return "Invalid image data."
        }
    }
    
    var domain: String {
        switch self{
        case .networkError(let from):
            return (from as NSError).domain
        default:
            return "Unknown domain"
        }
    }

    var code: Int {
        switch self{
        case .networkError(let from):
            return (from as NSError).code
        default:
            return 0
        }
    }

    var userInfo: [String : Any]? {
        switch self{
        case .networkError(let from):
            return (from as NSError).userInfo
        default:
            return nil
        }
    }
}
