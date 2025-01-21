//
//  APIManager.swift
//  FetchTakeHomeProject
//
//  Created by Sam Courtney on 1/16/25.
//

import Foundation

enum APIError: Error {
    /// Indicates the endpoint being used is bad - should never happen
    case invalidEndpoint
    // Could add additional API errors for usability and map from HTTP codes - for example, calling out unauthorized, retry allowed, etc
}

class RecipeAPIManager {
    static let endpoint = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
//    static let endpoints = [
//        "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json",
//        "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json",
//        "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
//    ]
    
    var session: URLSession = {
        var config = URLSessionConfiguration.ephemeral
        return URLSession(configuration: config)
    }()
    
    let decoder: JSONDecoder = {
        var jsonDecoder = JSONDecoder()
        // Account for the API having items like `source_url` that we want as `sourceUrl` in our model
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    func fetchRecipeBook() async throws -> RecipeBookAPIModel {
        guard let url = URL(string: RecipeAPIManager.endpoint) else {
            throw APIError.invalidEndpoint
        }
        
        // Could keep the response to figure out if we don't have data
        let (data, _) = try await session.data(from: url)
        return try decoder.decode(RecipeBookAPIModel.self, from: data)
    }
    
    func fetchRecipeBook(endpoint: String) async throws -> RecipeBookAPIModel {
        // Could add logic here to prevent further requests if the user spammed reload somehow (ex drag to refresh), but outside requested scope
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidEndpoint
        }
        
        // Could keep the response to figure out if we don't have data
        let (data, _) = try await session.data(from: url)
        return try decoder.decode(RecipeBookAPIModel.self, from: data)
    }
}
