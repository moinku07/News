//
//  NewsTests.swift
//  NewsTests
//
//  Created by Moin Uddin on 4/3/2023.
//

import XCTest
@testable import News
import Combine

class NewsTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() async throws {
        executionTimeAllowance = 1.0
        
        MockServiceManager.shared.setServiceAvailable()
    }

    override func tearDownWithError() throws {
        cancellables
            .forEach {
                $0.cancel()
            }
        cancellables.removeAll()
    }

}
