//
//  PushCodePointTests.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/6/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import XCTest
import PushInterpreter


class ProgramPointTests: XCTestCase {

    func testIntPointsAreInitializedRight() {
        let myPoint = IntPoint(i:13)
        XCTAssertTrue(myPoint.value == 13, "Program Point has wrong value")
    }
    
    func testFloatPointsAreInitializedRight() {
        let myPoint = FloatPoint(d:13.1415)
        XCTAssertTrue(myPoint.value == 13.1415, "Program Point has wrong value")
    }
    
    func testBoolPointsAreInitializedRight() {
        let myPoint = BoolPoint(b:false)
        XCTAssertTrue(myPoint.value == false, "Program Point has wrong value")
    }

    func testCodePointsAreInitializedRight() {
        let myPoint = CodePoint(s:"7 9 + )")
        XCTAssertTrue(myPoint.value == "7 9 + )", "Program Point has wrong value")
    }
}
