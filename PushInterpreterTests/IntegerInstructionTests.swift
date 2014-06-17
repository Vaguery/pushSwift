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
    

    func test_IntAdd() {
        let myPI = PushInterpreter(script:"2 3 int_add")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 5 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }
    
    func test_IntArchive() {
        let myPI = PushInterpreter(script:"1 int_archive 2 3 4")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 2 3 4 1 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    
    func test_IntDefine() {
        let myPI = PushInterpreter(script:"foo 11 int_define foo foo foo")
        myPI.run()
        XCTAssertTrue(myPI.bindings.count > 0, "Expected \(myPI.bindings) to include foo")
        XCTAssertTrue(myPI.intStack.description == "[ 11 11 11 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    
    func test_IntDepth() {
        let myPI = PushInterpreter(script:"1 2 3 4 1 2 3 4 int_depth")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 1 2 3 4 1 2 3 4 8 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    
    func test_IntDiv() {
        let myPI = PushInterpreter(script:"70 11 int_div")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 6 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    
    func test_IntDivMod() {
        let myPI = PushInterpreter(script:"70 11 int_divmod")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 6 4 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }
    
    func test_IntDup() {
        let myPI = PushInterpreter(script:"70 11 int_dup")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 70 11 11 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    
    func test_IntEqual() {
        let myPI = PushInterpreter(script:"70 11 int_equal -3 -3 int_equal")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    func test_IntFlip() {
        let myPI = PushInterpreter(script:"1 2 3 4 int_flip")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 4 3 2 1 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    
    func test_IntFlush() {
        let myPI = PushInterpreter(script:"1 2 3 int_flush 4 5 6")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 4 5 6 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }
    
    func test_IntFromBool() {
        let myPI = PushInterpreter(script:"F T int_fromBool int_fromBool")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 1 0 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    
    func test_IntGreaterThan() {
        let myPI = PushInterpreter(script:"70 11 int_greaterThan -3 9 int_greaterThan")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }

    func test_IntIsPositive() {
        let myPI = PushInterpreter(script:"9 int_isPositive -1 int_isPositive")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }


    func test_IntLessThan() {
        let myPI = PushInterpreter(script:"70 11 int_lessThan -3 9 int_lessThan")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    func test_IntMax() {
        let myPI = PushInterpreter(script:"70 11 int_max -3 9 int_max")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 70 9 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }
    
    func test_IntMin() {
        let myPI = PushInterpreter(script:"70 11 int_min -3 9 int_min")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 11 -3 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    
    func test_IntModulo() {
        let myPI = PushInterpreter(script:"70 11 int_mod")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 4 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    func test_IntMultiply() {
        let myPI = PushInterpreter(script:"70 11 int_multiply")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 770 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }
    
    func test_IntPop() {
        let myPI = PushInterpreter(script:"1 2 3 4 int_pop")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 1 2 3 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    
    
    func test_IntRotate() {
        let myPI = PushInterpreter(script:"1 2 3 int_rotate")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 2 3 1 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }


    
    func test_IntSubtract() {
        let myPI = PushInterpreter(script:"2 3 int_subtract")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ -1 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }
    
    func test_IntSwap() {
        let myPI = PushInterpreter(script:"1 2 3 4 int_swap")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 1 2 4 3 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }
    
    func test_IntYank() {
        let myPI = PushInterpreter(script:"1 2 3 4 5 6 7 -2 int_yank")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 1 2 3 4 5 7 6 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }
    
    
    func test_IntYankDup() {
        let myPI = PushInterpreter(script:"1 2 3 4 5 6 7 -2 int_yankDup")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 1 2 3 4 5 6 7 6 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }



    
    
}


