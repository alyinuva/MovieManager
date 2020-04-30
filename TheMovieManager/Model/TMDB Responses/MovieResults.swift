//
//  MovieResults.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

struct MovieResults: Codable {
    // Este es el struct que usaremos para manjear el JSON que nos devuelve el task URLSession.shared.dataTask(with: Endpoints.getWatchlist.url que llamamos en TMDBClient
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
}
