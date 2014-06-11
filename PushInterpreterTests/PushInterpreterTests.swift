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
//
//    // swap
//    
//    func testSwapDoesNothingIfStackLacksTwoItems() {
//        var myIntStack = PushStack<IntPoint>()
//        myIntStack.push(IntPoint(i:111))
//        myIntStack.swap()
//        XCTAssertTrue(myIntStack.length() == 1, "Should not have changed")
//        XCTAssertTrue(myIntStack.items[0].value == 111, "Should not have changed")
//    }
//
//    func testSwapRearrangesItems() {
//        var myIntStack = PushStack<IntPoint>()
//        myIntStack.push(IntPoint(i:111))
//        myIntStack.push(IntPoint(i:22))
//        myIntStack.push(IntPoint(i:3))
//        myIntStack.swap()
//        XCTAssertTrue(myIntStack.items[2].value == 22, "Should swap top two items")
//        XCTAssertTrue(myIntStack.items[1].value == 3, "Should swap top two items")
//        XCTAssertTrue(myIntStack.items[0].value == 111, "Should not affect lower items in stack")
//    }
//    
//    // dup
//    
//    func testDupDoesNothingIfStackIsEmpty() {
//        var myIntStack = PushStack<IntPoint>()
//        myIntStack.dup()
//        XCTAssertTrue(myIntStack.length() == 0, "Should not have changed")
//    }
//
//    func testDupCreatesAnewItemRatherThanCopyingReferencesForSimpleItems() {
//        var myIntStack = PushStack<IntPoint>()
//        myIntStack.push(IntPoint(i:3))
//        myIntStack.push(IntPoint(i:5))
//        // ok now dup that
//        myIntStack.dup()
//        let top_one = myIntStack.pop()
//        let second_one = myIntStack.pop()
//        XCTAssertTrue(top_one!.value == second_one!.value, "PushStack#dup should clone items")
//    }

    
//    func testDupCreatesAnewItemRatherThanCopyingReferencesForReferenceObjects() {
//        let arrayPoint1 = PushCodePoint<Int[]>(value: [1,2,3,4])
//        let arrayPoint2 = PushCodePoint<Int[]>(value: [9,8,7,6])
//        var myArrayStack = PushStack<PushCodePoint<Int[]>>()
//        myArrayStack.push(arrayPoint1)
//        myArrayStack.push(arrayPoint2)
//        // ok now dup that
//        myArrayStack.dup()
//        let top_one = myArrayStack.pop()
//        let second_one = myArrayStack.pop()
//        // TODO
////        XCTAssertTrue(top_one == second_one, "PushStack#dup should create identical items")
////        XCTAssertFalse(top_one === second_one, "PushStack#dup should create new items")
//    }
//    
}


