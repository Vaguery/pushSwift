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
    
    
    // create and run scripts
    
    func test_manyScripts() {
        for i in 1...100 {
            var guy = PushAnswer(length: 100)
            var runner = PushInterpreter(script:guy.script,bindings:guy.literals)
            runner.run()
            println("\(i), \(runner.steps),  \(runner.codeStack.items), \(runner.floatStack.items), \(runner.intStack.items), \(runner.boolStack.items), \(runner.rangeStack.items)\n")
        }
    }

    
}
