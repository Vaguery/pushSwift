//
//  FloatInstructionTests.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/13/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import XCTest
import PushInterpreter

class FloatInstructionTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_FloatAbs() {
        let myPI = PushInterpreter(script:"9.5 float_abs -1.25 float_abs")
        myPI.run()
        XCTAssertTrue(myPI.floatStack.description == "[ 9.5 1.25 ]", "Didn't expect stack to be \(myPI.floatStack.description)")
    }
    
    
    func test_FloatArchive() {
        let myPI = PushInterpreter(script:"1.0 float_archive 2.0 3.0")
        myPI.run()
        XCTAssertTrue(myPI.floatStack.description == "[ 2.0 3.0 1.0 ]", "Didn't expect stack to be \(myPI.floatStack.description)")
    }

    func test_FloatDefine() {
        let myPI = PushInterpreter(script:"foo 4.5 float_define foo foo foo")
        myPI.run()
        XCTAssertTrue(myPI.bindings.count > 0, "Expected \(myPI.bindings) to include foo")
        XCTAssertTrue(myPI.floatStack.description == "[ 4.5 4.5 4.5 ]", "Didn't expect stack to be \(myPI.floatStack.description)")
    }
    
    func test_FloatDepth() {
        let myPI = PushInterpreter(script:"1.0 2.0 3.0 4.0 float_depth")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 4 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    
    func test_FloatDup() {
        let myPI = PushInterpreter(script:"3.5 float_dup")
        myPI.run()
        XCTAssertTrue(myPI.floatStack.description == "[ 3.5 3.5 ]", "Didn't expect stack to be \(myPI.floatStack.description)")
    }

    func test_FloatEqual() {
        let myPI = PushInterpreter(script:"3.17 3.17 float_equal 1.0 2.0 float_equal")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }

    
    func test_FloatFlip() {
        let myPI = PushInterpreter(script:"1.0 2.0 3.0 float_flip")
        myPI.run()
        XCTAssertTrue(myPI.floatStack.description == "[ 3.0 2.0 1.0 ]", "Didn't expect stack to be \(myPI.floatStack.description)")
    }
    
    
    func test_FloatFlush() {
        let myPI = PushInterpreter(script:"1.0 2.0 3.0 float_flush")
        myPI.run()
        XCTAssertTrue(myPI.floatStack.description == "[ ]", "Didn't expect stack to be \(myPI.floatStack.description)")
    }


    
    func test_FloatFromBool() {
        let myPI = PushInterpreter(script:"F float_fromBool T float_fromBool")
        myPI.run()
        XCTAssertTrue(myPI.floatStack.description == "[ 0.0 1.0 ]", "Didn't expect stack to be \(myPI.floatStack.description)")
    }
    
    func test_FloatFromInt() {
        let myPI = PushInterpreter(script:"-1881 float_fromInt")
        myPI.run()
        XCTAssertTrue(myPI.floatStack.description == "[ -1881.0 ]", "Didn't expect stack to be \(myPI.floatStack.description)")
    }

    
    func test_FloatGreaterThan() {
        let myPI = PushInterpreter(script:"1.0 -2.0 float_greaterThan 3.0 3.0 float_greaterThan")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }


    func test_FloatIsPositive() {
        let myPI = PushInterpreter(script:"9.5 float_isPositive -1.25 float_isPositive")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }

    func test_FloatLessThan() {
        let myPI = PushInterpreter(script:"-111.0 -2.0 float_lessThan 3.0 3.0 float_lessThan")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    func test_FloatMod() {
        let myPI = PushInterpreter(script:"1.5 1.125 float_mod -11.0 3.125 float_mod 0.0 4.2625 float_mod 3.25 0.0 float_mod")
        myPI.run()
        XCTAssertTrue(myPI.floatStack.description == "[ 0.375 -1.625 0.0 ]", "Didn't expect stack to be \(myPI.floatStack.description)")
    }


    func test_FloatPop() {
        let myPI = PushInterpreter(script:"1.0 2.0 3.0 float_pop")
        myPI.run()
        XCTAssertTrue(myPI.floatStack.description == "[ 1.0 2.0 ]", "Didn't expect stack to be \(myPI.floatStack.description)")
    }
    

    
    func test_FloatRotate() {
        let myPI = PushInterpreter(script:"1.1 2.2 3.3 float_rotate")
        myPI.run()
        XCTAssertEqualWithAccuracy(myPI.floatStack.items[0].value as Double, 2.2, 0.0001, "Didn't expect stack to be \(myPI.floatStack.description)")
        XCTAssertEqualWithAccuracy(myPI.floatStack.items[1].value as Double, 3.3, 0.0001, "Didn't expect stack to be \(myPI.floatStack.description)")
        XCTAssertEqualWithAccuracy(myPI.floatStack.items[2].value as Double, 1.1, 0.0001, "Didn't expect stack to be \(myPI.floatStack.description)")
    }

    func test_FloatShove() {
        let myPI = PushInterpreter(script:"1.0 2.0 3.0 4.0 5.0 2 float_shove ")
        myPI.run()
        XCTAssertTrue(myPI.floatStack.description == "[ 1.0 2.0 5.0 3.0 4.0 ]", "Didn't expect stack to be \(myPI.floatStack.description)")
    }
    
    func test_FloatSwap() {
        let myPI = PushInterpreter(script:"1.0 2.0 3.0 4.0 5.0 float_swap")
        myPI.run()
        XCTAssertTrue(myPI.floatStack.description == "[ 1.0 2.0 3.0 5.0 4.0 ]", "Didn't expect stack to be \(myPI.floatStack.description)")
    }

    
    func test_FloatYank() {
        let myPI = PushInterpreter(script:"2 1.5 2.5 3.5 4.5 5.5 float_yank")
        myPI.run()
        XCTAssertTrue(myPI.floatStack.description == "[ 1.5 2.5 4.5 5.5 3.5 ]", "Didn't expect stack to be \(myPI.floatStack.description)")
    }
    
    
    func test_FloatYankDup() {
        let myPI = PushInterpreter(script:"2 1.5 2.5 3.5 4.5 5.5 float_yankDup")
        myPI.run()
        XCTAssertTrue(myPI.floatStack.description == "[ 1.5 2.5 3.5 4.5 5.5 3.5 ]", "Didn't expect stack to be \(myPI.floatStack.description)")
    }
    
}
