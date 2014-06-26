//
//  IntegrationTests.swift
//  IntegrationTests
//
//  Created by Bill Tozier on 6/22/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import XCTest
import PushInterpreter

class IntegrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    // create and run scripts
    
    func test_manyScripts() {
        for i in 1..100 {
            var guy = PushAnswer(length: 100)
            var runner = PushInterpreter(script:guy.script,bindings:guy.literals)
            runner.run()
            println("\(i), \(runner.steps),  \(runner.codeStack.items), \(runner.floatStack.items), \(runner.intStack.items), \(runner.boolStack.items), \(runner.rangeStack.items)\n")
        }
    }

    
}
