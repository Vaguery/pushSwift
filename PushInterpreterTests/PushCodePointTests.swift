//
//  PushCodePointTests.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/6/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import XCTest
import PushInterpreter


class PushCodePointTests: XCTestCase {

    func testIntCodePointInitializedRight() {
        let intPoint = PushCodePoint<Int>(value: 44)
        XCTAssertTrue(intPoint.value == 44, "Code point has wrong value")
    }
    
    func testBoolCodePointInitializedRight() {
        let boolPoint = PushCodePoint<Bool>(value: false)
        XCTAssertTrue(boolPoint.value == false, "Code point has wrong value")
    }
    
    func testDoubleCodePointInitializedRight() {
        let doublePoint = PushCodePoint<Double>(value: -771.221)
        XCTAssertTrue(doublePoint.value == -771.221, "Code point has wrong value")
    }
}
