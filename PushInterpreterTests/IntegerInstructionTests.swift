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

    func testIntDivMod() {
        let myPI = PushInterpreter(script:"70 11 int_divmod")
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

    func testIntLessThan() {
        let myPI = PushInterpreter(script:"70 11 int_lessThan -3 9 int_lessThan")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }

    func testIntEqual() {
        let myPI = PushInterpreter(script:"70 11 int_equal -3 -3 int_equal")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }

    func testIntGreaterThan() {
        let myPI = PushInterpreter(script:"70 11 int_greaterThan -3 9 int_greaterThan")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    func testIntMax() {
        let myPI = PushInterpreter(script:"70 11 int_max -3 9 int_max")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 70 9 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    
    func testIntMin() {
        let myPI = PushInterpreter(script:"70 11 int_min -3 9 int_min")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 11 -3 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

}


