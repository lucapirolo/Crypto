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
        }
    }
}
