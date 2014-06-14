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
    
    func test_FloatAbs() {
        let myPI = PushInterpreter(script:"9.5 float_abs -1.25 float_abs")
        myPI.run()
        XCTAssertTrue(myPI.floatStack.description == "[ 9.5 1.25 ]", "Didn't expect stack to be \(myPI.floatStack.description)")
    }
    
    func test_FloatDefine() {
        let myPI = PushInterpreter(script:"foo 4.5 float_define foo foo foo")
        myPI.run()
        XCTAssertTrue(myPI.bindings.count > 0, "Expected \(myPI.bindings) to include foo")
        XCTAssertTrue(myPI.floatStack.description == "[ 4.5 4.5 4.5 ]", "Didn't expect stack to be \(myPI.floatStack.description)")
    }

    
    func test_FloatRotate() {
        let myPI = PushInterpreter(script:"1.1 2.2 3.3 float_rotate")
        myPI.run()
        XCTAssertEqualWithAccuracy(myPI.floatStack.items[0].value as Double, 2.2, 0.0001, "Didn't expect stack to be \(myPI.floatStack.description)")
        XCTAssertEqualWithAccuracy(myPI.floatStack.items[1].value as Double, 3.3, 0.0001, "Didn't expect stack to be \(myPI.floatStack.description)")
        XCTAssertEqualWithAccuracy(myPI.floatStack.items[2].value as Double, 1.1, 0.0001, "Didn't expect stack to be \(myPI.floatStack.description)")
    }

    
}
