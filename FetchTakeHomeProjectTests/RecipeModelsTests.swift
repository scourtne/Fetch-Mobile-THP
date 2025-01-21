//
//  RecipeModelsTests.swift
//  FetchTakeHomeProject
//
//  Created by Sam Courtney on 1/20/25.
//

@testable import FetchTakeHomeProject
import XCTest

final class RecipeModelTests: XCTestCase {
    var jsonDecoder: JSONDecoder!
    
    override func setUp() {
        jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
        
    func testRecipeModelConversion() {
        let apiModel = RecipeAPIModel(cuisine: "American", name: "Optionals", photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg", uuid: "0c6ca6e7-e32a-4053-b824-2210e3b3312f", sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg")
        let fullModel = RecipeModel(apiModel: apiModel)
        XCTAssertEqual(fullModel.id, fullModel.uuid)
        XCTAssertEqual(apiModel.uuid, fullModel.uuid)
        XCTAssertEqual(apiModel.name, fullModel.name)
        XCTAssertEqual(apiModel.cuisine, fullModel.cuisine)
        XCTAssertEqual(apiModel.youtubeUrl, fullModel.youtubeUrl)
        XCTAssertEqual(apiModel.sourceUrl, fullModel.sourceUrl)
        XCTAssertEqual(apiModel.photoUrlLarge, fullModel.photoUrlLarge)
        XCTAssertEqual(apiModel.photoUrlSmall, fullModel.photoUrlSmall)
        
        let noUrlApiModel = RecipeAPIModel(cuisine: "American", name: "No Optionals", photoUrlLarge: nil, photoUrlSmall: nil, uuid: "0c6ca6e7-e32a-4053-b824-2210e3b3312f", sourceUrl: nil, youtubeUrl: nil)
        let noUrlModel = RecipeModel(apiModel: noUrlApiModel)
        XCTAssertEqual(noUrlModel.id, noUrlModel.uuid)
        XCTAssertEqual(noUrlApiModel.uuid, noUrlModel.uuid)
        XCTAssertEqual(noUrlApiModel.name, noUrlModel.name)
        XCTAssertEqual(noUrlApiModel.cuisine, noUrlModel.cuisine)
        XCTAssertNil(noUrlModel.youtubeUrl)
        XCTAssertNil(noUrlModel.sourceUrl)
        XCTAssertNil(noUrlModel.photoUrlLarge)
        XCTAssertNil(noUrlModel.photoUrlSmall)
    }
    
    func testFullConversion() {
        do {
            let data = try TestUtilities.loadMockData(.good)
            let apiModel = try jsonDecoder.decode(RecipeBookAPIModel.self, from: data)
            
            let fullModel = RecipeBookModel(apiModel: apiModel)
            XCTAssertEqual(fullModel.recipeCollections.count, 4)
            let unsortedNames = fullModel.recipeCollections.map { $0.cuisine }
            let sortedNames = unsortedNames.sorted()
            XCTAssertEqual(unsortedNames, sortedNames)
            XCTAssertEqual(fullModel.recipeCollections[0].id, fullModel.recipeCollections[0].cuisine)
        } catch {
            XCTFail("Encountered error in testing models \(String(describing: error))")
        }
    }
}
