//
//  ImageCacheTests.swift
//  FetchTakeHomeProject
//
//  Created by Sam Courtney on 1/20/25.
//

@testable import FetchTakeHomeProject
import XCTest

final class ImageFetcherTests: XCTestCase {
    var imageFetcher: ImageFetcher!
    
    override func setUp() {
        imageFetcher = ImageFetcher()
    }
    
    func testCache() async throws {
        validateCacheEmpty()
        
        _ = try await imageFetcher.image(at: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")
        validateCacheCount(1)
        
        _ = try await imageFetcher.image(at: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")
        validateCacheCount(2)
        
        _ = try await imageFetcher.image(at: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")
        validateCacheCount(2)
        XCTAssertNotNil(imageFetcher.imageCache.object(forKey: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"))
    }
    
    func validateCacheEmpty() {
        validateCacheCount(0)
    }
    
    func validateCacheCount(_ expected: Int) {
        if let all = imageFetcher.imageCache.value(forKey: "allObjects") as? NSArray {
            XCTAssertEqual(all.count, expected)
        } else {
            XCTFail("Cache is empty")
        }
    }
}
