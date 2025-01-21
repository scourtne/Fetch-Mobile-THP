//
//  EmptyViewModelTests.swift
//  FetchTakeHomeProject
//
//  Created by Sam Courtney on 1/20/25.
//

@testable import FetchTakeHomeProject
import XCTest

final class EmptyStateViewModelTests: XCTestCase {
    func testFormattedTimestamp() {
        let model = EmptyViewModel(timestamp: Date(timeIntervalSince1970: 1724949001))
        // There's a nonblocking space causing problems with testing exact matches, and nothing I do removes it
        XCTAssertTrue(model.formattedTimestamp.contains("As of Aug 29, 2024 at 12:30"))
    }
}
