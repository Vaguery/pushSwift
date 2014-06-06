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
        var myIntStack = PushStack<Int>()
        XCTAssertTrue(myIntStack.items.count == 0, "New PushStack should be empty")
    }
    
    /////////////////////////
    // push
    
    func testPushStackPushing() {
        var myIntStack = PushStack<Int>()
        myIntStack.push(3)
        XCTAssertTrue(myIntStack.length() == 1, "Integer was not pushed")
    }
    
    func testPushStackrepeatedPushing() {
        var myIntStack = PushStack<Int>()
        myIntStack.push(3)
        myIntStack.push(2)
        myIntStack.push(1)
        XCTAssertTrue(myIntStack.length() == 3, "Not enough items on the stack")
    }
    
    // pop
    
    func testPushStackPoppingRetrievesTopItem() {
        var myIntStack = PushStack<Int>()
        myIntStack.push(11)
        XCTAssertTrue(myIntStack.pop() == 11, "Topmost item on stack was not returned")
    }
    
    func testPoppingRemovesItem() {
        var myIntStack = PushStack<Int>()
        myIntStack.push(111)
        myIntStack.push(22)
        myIntStack.push(3)
        let poppedInt = myIntStack.pop()
        XCTAssertTrue(myIntStack.length() == 2, "Topmost item was not removed")
        XCTAssertTrue(myIntStack.items[1] == 22, "Second item should be on top")
    }
    
    func testPoppingReturnsNoValueWhenStackIsEmpty() {
        var myIntStack = PushStack<Int>()
        myIntStack.push(111)
        let poppedInt1:Int? = myIntStack.pop()
        XCTAssertTrue(poppedInt1 == 111, "Last item was not removed")
        XCTAssertTrue(myIntStack.length() == 0, "Stack should be empty")
        let poppedInt2:Int? = myIntStack.pop()
        XCTAssertTrue(poppedInt2 == nil, "An item was retrieved")
    }
    
    // swap
    
    func testSwapDoesNothingIfStackLacksTwoItems() {
        var myIntStack = PushStack<Int>()
        myIntStack.push(111)
        myIntStack.swap()
        XCTAssertTrue(myIntStack.length() == 1, "Should not have changed")
        XCTAssertTrue(myIntStack.items[0] == 111, "Should not have changed")
    }
    
    func testSwapRearrangesItems() {
        var myIntStack = PushStack<Int>()
        myIntStack.push(111)
        myIntStack.push(22)
        myIntStack.push(3)
        myIntStack.swap()
        XCTAssertTrue(myIntStack.items == [111,3,22], "Should swap top two items")
    }
    
    // dup
    
    func testDupDoesNothingIfStackIsEmpty() {
        var myIntStack = PushStack<Int>()
        myIntStack.dup()
        XCTAssertTrue(myIntStack.length() == 0, "Should not have changed")
    }
    
    func testDupCreatesAnewItemRatherThanCopyingReferencesForSimpleItems() {
        var myIntStack = PushStack<Int>()
        myIntStack.push(3)
        myIntStack.push(5)
        // ok now dup that
        myIntStack.dup()
        let top_one = myIntStack.pop()
        let second_one = myIntStack.pop()
        XCTAssertTrue(top_one == second_one, "PushStack#dup should clone items")
    }
    
    
    func testDupCreatesAnewItemRatherThanCopyingReferencesForComplexObjects() {
        var myIntStack1 = PushStack<Int>()
        var myIntStack2 = PushStack<Int>()
        var myStackStack = PushStack<PushStack<Int>>()
        myStackStack.push(myIntStack1)
        myStackStack.push(myIntStack2)
        // ok now dup that
        myStackStack.dup()
        let top_one = myStackStack.pop()
        let second_one = myStackStack.pop()
//        XCTAssertTrue(top_one == second_one, "PushStack#dup should create identical items")
//        XCTAssertFalse(top_one === second_one, "PushStack#dup should create new items")
    }
    
}


