//
//  RecipeAPIModelsTests.swift
//  FetchTakeHomeProject
//
//  Created by Sam Courtney on 1/20/25.
//

@testable import FetchTakeHomeProject
import XCTest

final class RecipeBookAPIModelTests: XCTestCase {
    var jsonDecoder: JSONDecoder!
    
    override func setUp() {
        jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func testEmptyResponse() {
        do {
            let data = try TestUtilities.loadMockData(.empty)
            let model = try jsonDecoder.decode(RecipeBookAPIModel.self, from: data)
            
            XCTAssertTrue(model.recipes.isEmpty)
        } catch {
            XCTFail("Encountered error in testing empty model \(String(describing: error))")
        }
    }
    
    func testGoodResponse() {
        do {
            let data = try TestUtilities.loadMockData(.good)
            let model = try jsonDecoder.decode(RecipeBookAPIModel.self, from: data)
            
            XCTAssertEqual(model.recipes.count, 4)
            // Validate the one without a youtube url has it missing properly
            let nullQuantityCount = model.recipes.compactMap({ $0.youtubeUrl }).count
            XCTAssertEqual(nullQuantityCount, 3)
        } catch {
            XCTFail("Encountered error in testing good model \(String(describing: error))")
        }
    }
    
    func testMalformedResponse() {
        do {
            let data = try TestUtilities.loadMockData(.malformed)
            XCTAssertThrowsError(try jsonDecoder.decode(RecipeBookAPIModel.self, from: data))
        } catch {
            XCTFail("Encountered error in testing malformed model \(String(describing: error))")
        }
    }
}
