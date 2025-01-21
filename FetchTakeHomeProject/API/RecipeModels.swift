//
//  RecipeModels.swift
//  FetchTakeHomeProject
//
//  Created by Sam Courtney on 1/19/25.
//

/// Representation of the container for recipes
struct RecipeBookModel {
    let recipeCollections: [RecipeCollection]
    
    init(apiModel: RecipeBookAPIModel) {
        var collections: [RecipeCollection] = []
        let recipesByCuisine = apiModel.recipesByCuisine
        recipesByCuisine.keys.forEach { cuisine in
            guard let recipes = recipesByCuisine[cuisine] else { return }
            collections.append(RecipeCollection(cuisine: cuisine, apiRecipes: recipes))
        }
        
        recipeCollections = collections.sorted { lhs, rhs in
            lhs.cuisine < rhs.cuisine
        }
    }
}

extension RecipeBookAPIModel {
    /// Convenience logic for breaking down a recipe book by cuisine
    var recipesByCuisine: [String: [RecipeAPIModel]] {
        Dictionary(grouping: recipes, by: { $0.cuisine })
    }
}

struct RecipeCollection: Identifiable {
    // Id should be uniqued based on how this is created
    var id: String {
        cuisine
    }
    let cuisine: String
    let recipes: [RecipeModel]
    
    init(cuisine: String, apiRecipes: [RecipeAPIModel]) {
        self.cuisine = cuisine
        self.recipes = apiRecipes.map { RecipeModel(apiModel: $0) }
    }
}

/// Representation of a recipe and associated metadata
struct RecipeModel: Identifiable {
    var id: String {
        uuid
    }
    
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
    
    init(apiModel: RecipeAPIModel) {
        self.cuisine = apiModel.cuisine
        self.name = apiModel.name
        self.photoUrlLarge = apiModel.photoUrlLarge
        self.photoUrlSmall = apiModel.photoUrlSmall
        self.uuid = apiModel.uuid
        self.sourceUrl = apiModel.sourceUrl
        self.youtubeUrl = apiModel.youtubeUrl
    }
}
