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
        let myPoint = PushPoint(int:13)
        XCTAssertTrue(myPoint.raw() as Int == 13, "Program Point has wrong value")
    }

    func testFloatPointsAreInitializedRight() {
        let myPoint = PushPoint(float:13.1415)
        XCTAssertTrue(myPoint.raw() as Double == 13.1415, "Program Point has wrong value")
    }

    func testBoolPointsAreInitializedRight() {
        let myPoint = PushPoint(bool:false)
        XCTAssertTrue(myPoint.raw() as Bool == false, "Program Point has wrong value")
    }
     
    func testInstructionPointsAreIntializedRight() {
        let myPoint = PushPoint(instruction: "bool_and")
        XCTAssertTrue(myPoint.raw() as String == "bool_and", "Program Point has wrong value")
    }
    
    func testNamePointsAreIntializedRight() {
        let myPoint = PushPoint(name: "foo")
        XCTAssertTrue(myPoint.raw() as String == "foo", "Program Point has wrong value")
    }

//    // BlockPoints are complicated....
    
    func testBlockPointsAreInitializedWithTheRightValues() {
        let myInt  = PushPoint(int:13)
        let myBool = PushPoint(bool:false)
        
        let myBlock = PushPoint(block: [myInt,myBool])
        let subTree = myBlock.raw() as PushPoint[]
        XCTAssertTrue(subTree.count == 2, "BlockPoint is missing elements")
        XCTAssertTrue(subTree[0].raw() as Int == 13, "BlockPoints should only contain PushPoints")
        XCTAssertTrue(subTree[1].raw() as Bool == false, "BlockPoints should only contain PushPoints")
    }

    func testBlockPointsWorkWithEmptyArrays() {
        let myBlock = PushPoint(block:[])
        let backOutAgain = myBlock.raw() as PushPoint[]
        XCTAssertTrue(backOutAgain.count == 0, "BlockPoint should have no elements")
    }
    
    func testBlockPointCreatedByValueNotByReference() {
        let myInt = PushPoint(int:13)
        let myBlock = PushPoint(block: [myInt])
        let subtree = myBlock.raw() as PushPoint[]
        XCTAssertFalse(subtree === myInt, "BlockPoints should contain COPIES of items passed in")
    }
    
    func testBlockPointDeepCopyOnCreation() {
        let myInt = PushPoint(int:13)
        var myBlock1 = PushPoint(block: [myInt])
        var myBlock2 = PushPoint(block: [myBlock1])
        let unwrap1 = myBlock2.raw() as PushPoint[]
        XCTAssertFalse(myBlock1 === unwrap1, "Items should not be identical")
    }
    
//    func testNestedBlockPointsAreStillAccessible() {
//        let myInt = IntPoint(i:13)
//        let myBool = BoolPoint(b:false)
//        var myBlock1 = BlockPoint(points: [myInt])
//        var myBlock2 = BlockPoint(points: [myBool, myBlock1])
//        XCTAssertTrue(myBlock1.value[0].value() == 13, "I should be able to read values inside a BlockPoint")
//    }
//
//    
//    
//    func testBlockPointAppend() {
//        let myInt = IntPoint(i:13)
//        let myBool = BoolPoint(b:false)
//        var myBlock = BlockPoint(points: [])
//        myBlock.append(myInt)
//        myBlock.append(myBool)
//        var subBlock = BlockPoint(points:[IntPoint(i:88)])
//        myBlock.append(subBlock)
//        XCTAssertTrue(myBlock.value.count == 3, "BlockPoint is missing elements")
//        
//        let subtree = myBlock.value[2]
//        XCTAssertTrue(subtree as? BlockPoint, "item should be a BlockPoint")
//        XCTAssertTrue(subtree.value[0] as? BlockPoint, "appended item changed type")
//    }
//    
    
    // they should conform to the Printable protocol
    // TODO
    
    // they should conform to the Equatable protocol
    // TODO
    
    // they should conform to the Comparable protocol
    // TODO
    
}
