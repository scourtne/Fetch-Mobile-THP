//
//  TestUtilities.swift
//  FetchTakeHomeProject
//
//  Created by Sam Courtney on 1/20/25.
//

import Foundation

final class TestUtilities {
    enum MockDataType {
        case empty
        case good
        case malformed
        
        var filename: String {
            switch self {
            case .empty:
                return "Empty"
            case .good:
                return "Valid"
            case .malformed:
                return "Malformed"
            }
        }
    }
    
    enum MockDataError: Error {
        case missingFile
    }
    
    static func mockDataPath(_ type: MockDataType) throws -> String {
        guard let path = Bundle(for: self).path(forResource: type.filename, ofType: "json") else {
            throw MockDataError.missingFile
        }

        return path
    }
    
    static func loadMockData(_ type: MockDataType) throws -> Data {
        let path = try mockDataPath(type)
        return try Data(contentsOf: URL(filePath: path), options: .mappedIfSafe)
    }
}
