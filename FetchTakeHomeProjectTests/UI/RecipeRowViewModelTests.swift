//
//  RecipeRowViewModelTests.swift
//  FetchTakeHomeProject
//
//  Created by Sam Courtney on 1/20/25.
//

@testable import FetchTakeHomeProject
import XCTest

final class RecipeRowViewModelTests: XCTestCase {
    var completeTestModel: RecipeRowViewModel!
    var noUrlTestModel: RecipeRowViewModel!
    var imageFetcher: ImageFetcher!
    
    override func setUp() {
        imageFetcher = ImageFetcher()
        let fullRecipe = RecipeModel(apiModel: RecipeAPIModel(cuisine: "American",
                                                              name: "English Muffin",
                                                              photoUrlLarge: "http://photo.com/big",
                                                              photoUrlSmall: "http://photo.com/small",
                                                              uuid: "12345",
                                                              sourceUrl: "http://source.com/recipe1",
                                                              youtubeUrl: "http://youtube.com/bogus"))
        completeTestModel = RecipeRowViewModel(recipe: fullRecipe, imageFetcher: imageFetcher)
        let noUrlRecipe = RecipeModel(apiModel: RecipeAPIModel(cuisine: "Swiss",
                                                               name: "Hot Chocolate",
                                                               photoUrlLarge: nil,
                                                               photoUrlSmall: nil,
                                                               uuid: "67890",
                                                               sourceUrl: nil,
                                                               youtubeUrl: nil))
        noUrlTestModel = RecipeRowViewModel(recipe: noUrlRecipe, imageFetcher: imageFetcher)
        
    }
    
    func testFormatName() {
        XCTAssertEqual("English Muffin", completeTestModel.formattedName)
        XCTAssertEqual("Hot Chocolate", noUrlTestModel.formattedName)
    }
    
    func testFormatCuisine() {
        XCTAssertEqual("American Cuisine", completeTestModel.formattedCuisine)
        XCTAssertEqual("Swiss Cuisine", noUrlTestModel.formattedCuisine)
    }
    
    func testSource() {
        if let (string, url) = completeTestModel.source {
            XCTAssertEqual("Source", string)
            XCTAssertEqual(URL(string: "http://source.com/recipe1"), url)
        } else {
            XCTFail("Missing source tuple")
        }
        
        XCTAssertNil(noUrlTestModel.source)
    }
    
    func testYoutube() {
        if let (string, url) = completeTestModel.youtube {
            XCTAssertEqual("Video", string)
            XCTAssertEqual(URL(string: "http://youtube.com/bogus"), url)
        } else {
            XCTFail("Missing youtube tuple")
        }

        XCTAssertNil(noUrlTestModel.youtube)
    }
}
