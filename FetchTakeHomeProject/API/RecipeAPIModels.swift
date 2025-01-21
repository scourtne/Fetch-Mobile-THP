//
//  APIModels.swift
//  FetchTakeHomeProject
//
//  Created by Sam Courtney on 1/16/25.
//

import Foundation

/// Representation of the container for recipes
struct RecipeBookAPIModel: Codable {
    /// List of recipes
    let recipes: [RecipeAPIModel]
}

/// Representation of a recipe and associated metadata
///
/// Note: it is assumed you're running the JSON decoding using the `.convertFromSnakeCase` strategy
struct RecipeAPIModel: Codable {
    /// The cuisine of the recipe
    let cuisine: String
    
    /// The name of the recipe
    let name: String

    /// The URL of the recipes’s full-size photo.
    let photoUrlLarge: String?

    /// The URL of the recipes’s small photo. Useful for list view
    let photoUrlSmall: String?

    /// The unique identifier for the receipe. Represented as a UUID
    let uuid: String

    /// The URL of the recipe's original website
    let sourceUrl: String?

    /// The URL of the recipe's YouTube video
    let youtubeUrl: String?
}
