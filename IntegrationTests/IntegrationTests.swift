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
            var guy = PushAnswer(
                length: 100,
                otherTokens:["(",")","«int»","«bool»","«float»","x"])
            var results = [String]()
            
            println("---\n\(guy.script)")
            
            for x in 1...3 {
                guy.resetWithBindings(["x":"\(x)"])
                guy.run()
//                println("\n\(i), \(guy.interpreter.steps)")
//                println("\n\(guy.interpreter.codeStack.items), \(guy.interpreter.floatStack.items), \(guy.interpreter.intStack.items), \(guy.interpreter.boolStack.items), \(guy.interpreter.rangeStack.items)")
                if let sortof_returned = guy.interpreter.intStack.pop() {
                    results.append(sortof_returned.description)
                } else {
                    results.append("No Answer")
                }
            }
            println("\(results)")
        }
    }

    
}
