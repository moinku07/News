//
//  NewsUITests.swift
//  NewsUITests
//
//  Created by Moin Uddin on 4/3/2023.
//

import XCTest

class NewsUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    var existenceCheckTimeAllowance: TimeInterval = 2

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        addLaunchArguments([.uiTest])
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
}

extension NewsUITests{
    func addLaunchArguments(_ args: [LaunchArguments]){
        for arg in args{
            if !app.launchArguments.contains(arg.rawValue){
                app.launchArguments += [arg.rawValue]
            }
        }
    }
}
