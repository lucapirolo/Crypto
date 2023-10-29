//
//  Pagination.swift
//  Crypto
//
//  Created by Luca Pirolo on 29/10/2023.
//

import Foundation

/// Represents pagination information for data fetching.
struct Pagination {
    /// The current page index.
    var currentPage: Int
    
    /// The number of items per page.
    var itemsPerPage: Int

    /// A standard instance of Pagination with predefined defaults.
    static let standard = Pagination(currentPage: 0, itemsPerPage: 200)

    /// Private initializer to control the creation of instances with default values.
    private init(currentPage: Int, itemsPerPage: Int) {
        self.currentPage = currentPage
        self.itemsPerPage = itemsPerPage
    }

    /// Creates a new pagination instance with specified page and items per page.
    init(page: Int, perPage: Int) {
        self.currentPage = page
        self.itemsPerPage = perPage
    }
    
    /// Increments the currentPage property by 1
    mutating func nextPage() {
        currentPage += 1
    }
}
