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
    
    
    func testRangePointsAreIntializedRight() {
        let myPoint = PushPoint.Range(-7,11)
        let (start,end) = myPoint.value as (Int,Int)
        XCTAssertTrue( start == -7, "Range start should not be \(start)")
        XCTAssertTrue( end == 11, "Range end shoud not be \(end)")
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
    
    
    func testBlockSubtreeExtractor() {
        let myBlock = PushPoint.Block(
            [PushPoint.Integer(4),
             PushPoint.Instruction("noop")])
        let s = myBlock.subtree()!
        XCTAssertTrue(s[0].value as Int == 4, "nope")
    }
    
    func testNestedBlockPointsAreStillAccessible() {
        let myInt = PushPoint.Integer(13)
        let myBool = PushPoint.Boolean(false)
        var myBlock1 = PushPoint.Block([myInt])
        var myBlock2 = PushPoint.Block([myBool, myBlock1])
        let intAgain = myBlock2.subtree()![1].subtree()![0].value as Int
        XCTAssertTrue(intAgain == 13, "I should be able to read values inside a BlockPoint")
    }
    
    // they should conform to the Printable protocol
    
    func testIntegersPrint() {
        var printed = PushPoint.Integer(13).description
        XCTAssertTrue(printed == "13", "Unexpected PushPoint description: \(printed)")
        
        printed = PushPoint.Integer(-13).description
        XCTAssertTrue(printed == "-13", "Unexpected PushPoint description: \(printed)")
        
        printed = PushPoint.Integer(-0).description
        XCTAssertTrue(printed == "0", "Unexpected PushPoint description: \(printed)")
    }
    
    func testRangePrint() {
        var printed = PushPoint.Range(13,-812).description
        XCTAssertTrue(printed == "(13..-812)", "Unexpected PushPoint description: \(printed)")
    }

    
    func testFloatsPrint() {
        var printed = PushPoint.Float(13.13).description
        XCTAssertTrue(printed == "13.13", "Unexpected PushPoint description: \(printed)")
        
        printed = PushPoint.Float(-13.13).description
        XCTAssertTrue(printed == "-13.13", "Unexpected PushPoint description: \(printed)")

        printed = PushPoint.Float(-000.001).description
        XCTAssertTrue(printed == "-0.001", "Unexpected PushPoint description: \(printed)")
    }
    
    func testBoolsPrint() {
        var printed = PushPoint.Boolean(false).description
        XCTAssertTrue(printed == "F", "Unexpected PushPoint description: \(printed)")
        
        printed = PushPoint.Boolean(true).description
        XCTAssertTrue(printed == "T", "Unexpected PushPoint description: \(printed)")
    }
    
    func testNamesPrint() {
        var printed = PushPoint.Name("foo").description
        XCTAssertTrue(printed == "\"foo\"", "Unexpected PushPoint description: \(printed)")
        
        printed = PushPoint.Name("8 a01;").description
        XCTAssertTrue(printed == "\"8 a01;\"", "Unexpected PushPoint description: \(printed)")
    }

    func testInstructionsPrint() {
        var printed = PushPoint.Instruction("foo").description
        XCTAssertTrue(printed == ":foo", "Unexpected PushPoint description: \(printed)")
        
        printed = PushPoint.Instruction("int.add").description
        XCTAssertTrue(printed == ":int.add", "Unexpected PushPoint description: \(printed)")
    }

    func testBlocksPrint() {
        var tree = PushPoint.Block(PushInterpreter().parse(""))
        var printed = tree.description
        XCTAssertTrue(printed == "( )", "Unexpected PushPoint description: \(printed)")
        
        tree = PushPoint.Block(PushInterpreter().parse("1 2 3 ( 4 5 ) ( 6 7 )"))
        printed = tree.description
        XCTAssertTrue(printed == "( 1 2 3 ( 4 5 ) ( 6 7 ) )", "Unexpected PushPoint description: \(printed)")
    }


    // they should conform to the Equatable protocol
    // TODO
    
    // they should (where meaningful) conform to the Comparable protocol
    // TODO
    
}
