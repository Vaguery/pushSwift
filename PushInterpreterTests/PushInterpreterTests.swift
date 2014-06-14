//
//  PushInterpreterTests.swift
//  PushInterpreterTests
//
//  Created by Bill Tozier on 6/4/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import XCTest
import PushInterpreter

class StackTests: XCTestCase {
    
    /////////////////////////////////
    // initialization

    func testNewPushStackHasNoItems() {
        var myStack = PushStack()
        XCTAssertTrue(myStack.items.count == 0, "New PushStack should be empty")
    }
    
//    /////////////////////////
//    // push
    
    func testPushStackPushing() {
        var myStack = PushStack()
        myStack.push(PushPoint.Integer(33))
        XCTAssertTrue(myStack.length() == 1, "Integer was not pushed")
    }

    func testPushStackrepeatedPushing() {
        var myStack = PushStack()
        myStack.push(PushPoint.Integer(3))
        myStack.push(PushPoint.Integer(2))
        myStack.push(PushPoint.Integer(1))
        XCTAssertTrue(myStack.length() == 3, "Not enough items on the stack")
    }

    // pop
    
    func testPushStackPoppingRetrievesTopItem() {
        var myStack = PushStack()
        myStack.push(PushPoint.Integer(11))
        let item:PushPoint = myStack.pop()!
        XCTAssertTrue(item.value as Int == 11, "Topmost item on stack was not returned")
    }

    func testPoppingActuallyRemovesThePoppedItem() {
        var myStack = PushStack()
        myStack.push(PushPoint.Integer(3))
        myStack.push(PushPoint.Integer(2))
        myStack.push(PushPoint.Integer(1))
        let poppedInt:PushPoint = myStack.pop()!
        XCTAssertTrue(myStack.length() == 2, "Topmost item was not removed")
        XCTAssertTrue(myStack.items[1].value as Int == 2, "Second item should be on top")
    }
    
    func testPoppingReturnsNoValueWhenStackIsEmpty() {
        var myStack = PushStack()
        myStack.push(PushPoint.Integer(111))
        let popped:PushPoint = myStack.pop()!
        XCTAssertTrue(popped.value as Int == 111, "Values of PushPoints don't match")
        XCTAssertTrue(myStack.length() == 0, "Stack should be empty")
        let poppedInt2:PushPoint? = myStack.pop()
        XCTAssertTrue(poppedInt2 == nil, "An item was retrieved")
    }

    //  rotate
    
    func testRotateWithTwoItemsIsSwap() {
        var myStack = PushStack()
        myStack.push(PushPoint.Integer(1))
        myStack.push(PushPoint.Integer(2))
        myStack.rotate()
        XCTAssertTrue(myStack.description == "[ 2 1 ]", "Did not expect \(myStack.description)")
    }

    
    func testRotateWithThreeItemsWorksAsExpected() {
        var myStack = PushStack()
        myStack.push(PushPoint.Integer(1))
        myStack.push(PushPoint.Integer(2))
        myStack.push(PushPoint.Integer(3))
        myStack.rotate()
        XCTAssertTrue(myStack.description == "[ 2 3 1 ]", "Did not expect \(myStack.description)")
    }

    
    
    //  swap
    
    func testSwapDoesNothingIfStackLacksTwoItems() {
        var myStack = PushStack()
        myStack.push(PushPoint.Integer(123))
        myStack.swap()
        XCTAssertTrue(myStack.length() == 1, "Stack length should not have changed")
        XCTAssertTrue(myStack.items[0].value as Int == 123, "Stack items should not have changed")
    }

    func testSwapRearrangesItems() {
        var myIntStack = PushStack()
        myIntStack.push(PushPoint.Integer(111))
        myIntStack.push(PushPoint.Integer(22))
        myIntStack.push(PushPoint.Integer(3))
        myIntStack.swap()
        XCTAssertTrue(myIntStack.items[2].value as Int == 22, "Should have swapped top two items")
        XCTAssertTrue(myIntStack.items[1].value as Int == 3, "Should have swapped top two items")
        XCTAssertTrue(myIntStack.items[0].value as Int == 111, "Should not have affected lower items in stack")
    }

//    // dup
    
    func testDupDoesNothingIfStackIsEmpty() {
        var myIntStack = PushStack()
        myIntStack.dup()
        XCTAssertTrue(myIntStack.length() == 0, "Should not have changed")
    }

    func testDupCreatesAnewItem() {
        var myIntStack = PushStack()
        myIntStack.push(PushPoint.Integer(3))
        myIntStack.push(PushPoint.Integer(5))
        // ok now dup that
        myIntStack.dup()
        XCTAssertTrue(myIntStack.items[1].value as Int == myIntStack.items[2].value as Int, "PushStack#dup should have made an identical items")
    }

    func testDupAvoidsReferenceDuplicationForBlocks() {
        let i1 = PushPoint.Integer(1)
        let i2 = PushPoint.Integer(2)
        let i3 = PushPoint.Integer(9999)
        
        let b1 = PushPoint.Block([i1,i2])
        let s = PushStack()
        s.push(b1)
        s.dup()
        var tree1 = b1.value as PushPoint[]
        tree1[1] = i3
        
        let tree2 = s.items[1].value as PushPoint[]
        XCTAssertTrue(tree1[1].value as Int == 9999, "original block should have changed")
        XCTAssertTrue(tree2[1].value as Int == 2, "duplicated block should not have changed")
        XCTAssertFalse(tree1[1].value as Int == tree2[1].value as Int, "Items should be different")
    }
    
    
    func testDescription() {
        var s = PushStack()
        for i in 1...8 { s.push(PushPoint.Integer(i))}
        XCTAssertTrue(s.description == "[ 1 2 3 4 5 6 7 8 ]", "Did not expect \(s.description)")
    }
}


