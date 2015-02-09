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
        for i in 1...50 {
            var guy = PushAnswer(length: 50)
            guy.myInterpreter = PushInterpreter(script:guy.script,bindings:guy.literals)
            guy.run()
            println("---\n\(guy.script)")
            println("\n\(i), \(guy.myInterpreter.steps),  \(guy.myInterpreter.codeStack.items), \(guy.myInterpreter.floatStack.items), \(guy.myInterpreter.intStack.items), \(guy.myInterpreter.boolStack.items), \(guy.myInterpreter.rangeStack.items)")
            if let sortof_returned = guy.myInterpreter.intStack.pop() {
                println("\n\(sortof_returned.description)")
            } else {
                println("\nNo Answer")
            }
        }
    }

    
}
