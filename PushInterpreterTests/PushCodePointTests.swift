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
    
    // they should produce the expected items upon initialization

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
    
    func testInstructionPointsAreIntializedRight() {
        let myPoint = InstructionPoint(s: "bool_and")
        XCTAssertTrue(myPoint.value == "bool_and", "Program Point has wrong value")
    }
    
    func testNamePointsAreIntializedRight() {
        let myPoint = NamePoint(n: "foo")
        XCTAssertTrue(myPoint.value == "foo", "Program Point has wrong value")
    }

    func testBlockPointsAreInitializedWithTheRightValues() {
        let myInt = IntPoint(i:13)
        let myBool = BoolPoint(b:false)
        
        let myBlock = BlockPoint(points: [myInt,myBool])
        XCTAssertTrue(myBlock.contents.count == 2, "BlockPoint is missing elements")
        XCTAssertTrue(myBlock.contents[0] as? IntPoint, "BlockPoints should only contain PushPoints")
        XCTAssertTrue(myBlock.contents[1] as? BoolPoint, "BlockPoints should only contain PushPoints")
    }
    
    func testBlockPointsWorkWithEmptyArrays() {
        let myBlock = BlockPoint(points:[])
        XCTAssertTrue(myBlock.contents.count == 0, "BlockPoint should have no elements")
    }
    
    func testBlockPointCreatedByValueNotByReference() {
        let myInt = IntPoint(i:13)
        let myBool = BoolPoint(b:false)
        let myBlock = BlockPoint(points: [myInt,myBool])
        XCTAssertFalse(myBlock.contents[0] === myInt, "BlockPoints should contain COPIES of items passed in")
    }
    
    
    // they should conform to the Printable protocol
    // TODO
    
    // they should conform to the Equatable protocol
    // TODO
    
    // they should conform to the Comparable protocol
    // TODO
    
}
