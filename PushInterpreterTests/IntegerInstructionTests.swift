//
//  IntegerInstructionTests.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/11/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import XCTest
import PushInterpreter

class IntegerInstructionTests: XCTestCase {

    func testIntAdd() {
        let myPI = PushInterpreter(script:"2 3 int_add")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 5 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }
    
    func testIntSubtract() {
        let myPI = PushInterpreter(script:"2 3 int_subtract")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ -1 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }
    
    func testIntModulo() {
        let myPI = PushInterpreter(script:"70 11 int_mod")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 4 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    func testIntModDiv() {
        let myPI = PushInterpreter(script:"70 11 int_moddiv")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 6 4 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }
    
    func testIntDiv() {
        let myPI = PushInterpreter(script:"70 11 int_div")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 6 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    func testIntMultiply() {
        let myPI = PushInterpreter(script:"70 11 int_multiply")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 770 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }


}


