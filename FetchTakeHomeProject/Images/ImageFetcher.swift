//
//  ImageFetcher.swift
//  FetchTakeHomeProject
//
//  Created by Sam Courtney on 1/18/25.
//

import Foundation
import SwiftUI

enum ImageFetchError: Error {
    /// Indicates the image url provided is bad
    case invalidURL
    /// URL did not return valid image data
    case invalidImage
}

class ImageFetcher {
    /// Image cache containing a mapping of URL string to backing data
    var imageCache: NSCache<NSString, NSData> = {
        let cache = NSCache<NSString, NSData>()
        // No need to limit number of images, arbitrarily limit the image max size to 30 MB
        cache.totalCostLimit = 30 * 1024 * 1024
        return cache
    }()
    
    var session: URLSession = {
        var config = URLSessionConfiguration.ephemeral
        return URLSession(configuration: config)
    }()
        
    func image(at urlString: String) async throws -> UIImage {
        // 1. Check if the image is available in the cache
        if let cachedImageData = imageCache.object(forKey: urlString as NSString),
           let cachedImage = UIImage(data: cachedImageData as Data) {
            return cachedImage
        }
        
        // 2. Validate the URL - arguably this could go before hitting up the image cache, but nothing should be in the cache and it should be fast to validate.
        // For a production app, performance testing would be a useful long term consideration (although ideally we'd use a pre-built caching solution for the images)
        guard let url = URL(string: urlString) else {
            throw ImageFetchError.invalidURL
        }
        
        // 3. Fetch the image
        let (fetchedImageData, _) = try await session.data(from: url)
        
        // 4. Check the data is actually an image
        guard let fetchedImage = UIImage(data: fetchedImageData) else {
            throw ImageFetchError.invalidImage
        }
        
        // 5. Cache the image
        imageCache.setObject(fetchedImageData as NSData, forKey: urlString as NSString, cost: fetchedImageData.count)
        
        return fetchedImage
    }
}
