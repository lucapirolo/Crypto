//  BaseNetworkManager.swift
//  Crypto
//  Created by Luca Pirolo on 29/10/2023.

import Foundation

/// HTTP methods for network requests.
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// A base network manager for handling network requests.
class BaseNetworkManager {
    /// The base URL for the network requests.
    private let baseUrl = ApiConstants.coinGeckobaseUrl

    /// The URLSession used for making network requests.
    private let session: URLSession
    
    /// The JSON Decoder
    private let decoder = JSONDecoder()

    /// Initializes a new instance of the network manager.
    /// - Parameter session: The URLSession to be used for network requests. Defaults to `URLSession.shared`.
    init(session: URLSession = URLSession.shared) {
        self.session = session
        // Sets the decoding strategy for decoding date strings
        decoder.dateDecodingStrategy = .iso8601WithFractionalSeconds
    }

    /// Sends a network request and decodes the response.
    /// - Parameters:
    ///   - endpoint: The endpoint for the request.
    ///   - method: The HTTP method to use for the request.
    ///   - body: The body data to send with the request. Defaults to nil.
    ///   - responseType: The expected type of the response.
    ///   - pagination: Optional pagination information for the request.
    ///   - queryParams: Optional query parameters for the request.
    /// - Returns: A decoded object of type `T`.
    /// - Throws: `NetworkError` in case of any failure.
    func sendRequest<T: Decodable>(
        _ endpoint: String,
        method: HTTPMethod,
        body: Data? = nil,
        responseType: T.Type,
        pagination: Pagination? = nil,
        queryParams: [String: String]? = nil // <-- Add this line
    ) async throws -> T {
        var urlComponents = URLComponents(string: baseUrl + endpoint)
        
        // Append pagination parameters if provided.
        if let pagination = pagination, var components = urlComponents {
            addPaginationParameters(to: &components, pagination: pagination)
            urlComponents = components
        }

        // Append query parameters if provided.
        if let queryParams = queryParams, var components = urlComponents {
            addQueryParameters(to: &components, queryParams: queryParams)
            urlComponents = components
        }

        
        // Ensure a valid URL is formed.
        guard let apiUrl = urlComponents?.url else {
            throw NetworkError.invalidUrl
        }
        
        print(apiUrl)
        
        var urlRequest = URLRequest(url: apiUrl)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = body
        
        // Perform the network request.
        let (data, response) = try await session.data(for: urlRequest)
    
        
        // Validate the HTTP response.
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // Handle different status codes.
        switch httpResponse.statusCode {
            case 200...299:
                return try decoder.decode(responseType, from: data)
            case 429:
                throw NetworkError.tooManyRequests
            case 400...499:
                throw NetworkError.clientError(httpResponse.statusCode)
            case 500...599:
                throw NetworkError.serverError(httpResponse.statusCode)
            default:
                throw NetworkError.unexpectedStatusCode(httpResponse.statusCode)
        }

    }
    
    /// Adds pagination parameters to the URL components.
    /// - Parameters:
    ///   - urlComponents: The URL components to modify.
    ///   - pagination: The pagination information.
    private func addPaginationParameters(to urlComponents: inout URLComponents, pagination: Pagination) {
        let perPageItem = URLQueryItem(name: "per_page", value: String(pagination.itemsPerPage))
        let pageItem = URLQueryItem(name: "page", value: String(pagination.currentPage))
        
        if urlComponents.queryItems == nil {
            urlComponents.queryItems = [perPageItem, pageItem]
        } else {
            urlComponents.queryItems?.append(contentsOf: [perPageItem, pageItem])
        }
    }

    /// Adds query parameters to the URL components.
    /// - Parameters:
    ///   - urlComponents: The URL components to modify.
    ///   - queryParams: The query parameters.
    private func addQueryParameters(to urlComponents: inout URLComponents, queryParams: [String: String]) {
        for (key, value) in queryParams {
            let queryItem = URLQueryItem(name: key, value: value)
            if urlComponents.queryItems == nil {
                urlComponents.queryItems = [queryItem]
            } else {
                urlComponents.queryItems?.append(queryItem)
            }
        }
    }
}
