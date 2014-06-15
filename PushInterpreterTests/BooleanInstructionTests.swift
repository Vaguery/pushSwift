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
    
    
    func test_BoolAnd() {
        let myPI = PushInterpreter(script:"F F bool_and F T bool_and T F bool_and T T bool_and")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F F F T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    
    func test_BoolDefine() {
        let myPI = PushInterpreter(script:"F foo bool_define foo foo foo")
        myPI.run()
        XCTAssertTrue(myPI.bindings.count > 0, "Expected \(myPI.bindings) to include foo")
        XCTAssertTrue(myPI.boolStack.description == "[ F F F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    

    
    func test_BoolDepth() {
        let myPI = PushInterpreter(script:"F F T T F F T T bool_depth")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 8 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    
    func test_BoolDup() {
        let myPI = PushInterpreter(script:"F T bool_dup")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F T T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }


    func test_BoolEqual() {
        let myPI = PushInterpreter(script:"F T bool_equal T T bool_equal")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    func test_BoolFlip() {
        let myPI = PushInterpreter(script:"F T F F F T T T F T bool_flip")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T F T T T F F F T F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }

    
    func test_BoolFlush() {
        let myPI = PushInterpreter(script:"F F F F F bool_flush T")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }


    func test_BoolNot() {
        let myPI = PushInterpreter(script:"F bool_not")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    func test_BoolOr() {
        let myPI = PushInterpreter(script:"F F bool_or F T bool_or T F bool_or T T bool_or")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F T T T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    func test_BoolPop() {
        let myPI = PushInterpreter(script:"F F T bool_pop")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }

    
    func test_BoolRotate() {
        let myPI = PushInterpreter(script:"F F T bool_rotate")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F T F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    func test_BoolShove() {
        let myPI = PushInterpreter(script:"3 F F F F F T bool_shove")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F F F T F F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    func test_BoolShoveWorksWhenBoolIsEmpty() {
        let myPI = PushInterpreter(script:"3 bool_shove")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }


    func test_BoolSwap() {
        let myPI = PushInterpreter(script:"F F T bool_swap")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F T F ]", "Didn't expect stack to be \(myPI.boolStack.description)")

    }
    




}
