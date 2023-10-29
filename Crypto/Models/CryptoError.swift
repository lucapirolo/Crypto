//
//  CryptoError.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import Foundation

enum NetworkError: Error {
    case serverError(Int)                  // Contains the HTTP status code for better diagnosis
    case clientError(Int)                  // Contains the client-side HTTP status code (e.g. 404 Not Found, 401 Unauthorized)
    case conflictError(String?)            // Contains an optional message about the conflict
    case invalidUrl                        // URL creation failed
    case invalidResponse                   // Response is not a valid HTTP response
    case tooManyRequests                   // Too Many Requests within a given time
    case dataDecodingError(Error)          // Error while decoding the response
    case unknown                           // A fallback for other unknown errors
    case unexpectedStatusCode(Int)         // For HTTP status codes that are not explicitly handled

    var localizedDescription: String {
        switch self {
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .clientError(let statusCode):
            return "Client error with status code: \(statusCode)"
        case .conflictError(let message):
            return "Conflict error: \(message ?? "No details provided")"
        case .invalidUrl:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response received from the server"
        case .dataDecodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .unexpectedStatusCode(let statusCode):
            return "Unexpected status code: \(statusCode)"
        case .unknown:
            return "Unknown network error occurred"
        case .tooManyRequests:
            return "Please slow down and try again later."
        }
    }
    
    var alertItem: AlertItem {
           switch self {
           case .serverError:
               return AlertContext.invalidData

           case .clientError:
               return AlertContext.invalidResponse

           case .conflictError:
               return AlertItem.create(title: "Conflict Error", message: self.localizedDescription)

           case .invalidUrl:
               return AlertContext.invalidURL

           case .invalidResponse:
               return AlertContext.invalidResponse

           case .dataDecodingError:
               return AlertItem.create(title: "Decoding Error", message: self.localizedDescription)

           case .unexpectedStatusCode:
               return AlertItem.create(title: "Unexpected Error", message: self.localizedDescription)

           case .unknown:
               return AlertContext.unableToComplete
           case .tooManyRequests:
               return AlertItem.create(title: "Too Many Requests!", message: self.localizedDescription)

           }
       }
}
