//
//  BooleanInstructionTests.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/13/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import XCTest
import PushInterpreter

class BooleanInstructionTests: XCTestCase {
    
    func testBoolNot() {
        let myPI = PushInterpreter(script:"F bool_not")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    func testBoolEqual() {
        let myPI = PushInterpreter(script:"F T bool_equal T T bool_equal")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    
    func testBoolAnd() {
        let myPI = PushInterpreter(script:"F F bool_and F T bool_and T F bool_and T T bool_and")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F F F T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }


    func testBoolOr() {
        let myPI = PushInterpreter(script:"F F bool_or F T bool_or T F bool_or T T bool_or")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F T T T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }


}
