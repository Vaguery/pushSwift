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
        let myPoint = PushPoint.Integer(13)
        XCTAssertTrue(myPoint.value as Int == 13, "Program Point has wrong value")
    }

    func testFloatPointsAreInitializedRight() {
        let myPoint = PushPoint.Float(13.1415)
        XCTAssertTrue(myPoint.value as Double == 13.1415, "Program Point has wrong value")
    }

    func testBoolPointsAreInitializedRight() {
        let myPoint = PushPoint.Boolean(false)
        XCTAssertTrue(myPoint.value as Bool == false, "Program Point has wrong value")
    }
     
    func testInstructionPointsAreIntializedRight() {
        let myPoint = PushPoint.Instruction("bool_and")
        XCTAssertTrue(myPoint.value as String == "bool_and", "Program Point has wrong value")
    }
    
    func testNamePointsAreIntializedRight() {
        let myPoint = PushPoint.Name("foo")
        XCTAssertTrue(myPoint.value as String == "foo", "Program Point has wrong value")
    }

//    // BlockPoints are complicated....
    
    func testBlockPointsAreInitializedWithTheRightValues() {
        let myInt  = PushPoint.Integer(13)
        let myBool = PushPoint.Boolean(false)
        
        let myBlock = PushPoint.Block([myInt,myBool])
        let subTree = myBlock.value as PushPoint[]
        XCTAssertTrue(subTree.count == 2, "BlockPoint is missing elements")
        XCTAssertTrue(subTree[0].value as Int == 13, "BlockPoints should only contain PushPoints")
        XCTAssertTrue(subTree[1].value as Bool == false, "BlockPoints should only contain PushPoints")
    }

    func testBlockPointsWorkWithEmptyArrays() {
        let myBlock = PushPoint.Block([])
        let backOutAgain = myBlock.value as PushPoint[]
        XCTAssertTrue(backOutAgain.count == 0, "BlockPoint should have no elements")
    }
    
//    func testBlockPointCreatedByValueNotByReference() {
//        let myInt = PushPoint.Integer(13)
//        let myBlock = PushPoint.Block([myInt])
//        let subtree = myBlock.value as PushPoint[]
//        let recoveredIntPoint = subtree[0] as PushPoint
//        let myInt_ID = reflect(myInt as PushPoint).objectIdentifier
//        let new_ID = reflect(recoveredIntPoint as PushPoint).objectIdentifier
//        XCTAssertFalse(myInt_ID == new_ID, "\(new_ID) != \(myInt_ID) BlockPoints should contain COPIES of items passed in")
//    }
    
    
//    func testTofigureOutWhereRefsGo() {
//        let x:String = "foo"
//        let pushedX:PushPoint = PushPoint.Name(x)
//        
//        let x_ref:UInt = ObjectIdentifier(x).uintValue()
//        let pushedX_ref:UInt = ObjectIdentifier(pushedX).uintValue()
//        XCTAssertNotNil(x_ref, "Where's that ref?")
//        XCTAssertNotNil(pushedX_ref, "Where's that ref?")
//    }
    
//    func testBlockPointDeepCopyOnCreation() {
//    }
    
    
    func testBlockSubtreeExtractor() {
        let myBlock = PushPoint.Block(
            [PushPoint.Integer(4),
             PushPoint.Instruction("noop")])
        let s = myBlock.subtree()
        XCTAssertTrue(s[0].value as Int == 4, "nope")
    }
    
    func testNestedBlockPointsAreStillAccessible() {
        let myInt = PushPoint.Integer(13)
        let myBool = PushPoint.Boolean(false)
        var myBlock1 = PushPoint.Block([myInt])
        var myBlock2 = PushPoint.Block([myBool, myBlock1])
        let intAgain = myBlock2.subtree()[1].subtree()[0].value as Int
        XCTAssertTrue(intAgain == 13, "I should be able to read values inside a BlockPoint")
    }
    
    // they should conform to the Printable protocol
    // TODO
    
    // they should conform to the Equatable protocol
    // TODO
    
    // they should conform to the Comparable protocol
    // TODO
    
}
