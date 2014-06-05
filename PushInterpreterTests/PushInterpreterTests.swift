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
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPushing() {
        var myIntStack = PushStack<Int>()
        myIntStack.push(3)
        XCTAssertTrue(myIntStack.length() == 1, "Integers can be pushed")
    }
    
    func testMultiplePushing() {
        var myIntStack = PushStack<Int>()
        myIntStack.push(3)
        myIntStack.push(2)
        myIntStack.push(1)
        XCTAssertTrue(myIntStack.length() == 3, "Items accumulate on the stack")
    }
    
    func testPopping() {
        var myIntStack = PushStack<Int>()
        myIntStack.push(11)
        XCTAssertTrue(myIntStack.pop() == 11, "You get the topmost item when popping from stack")
    }
    
    func testPoppingRemovesItem() {
        var myIntStack = PushStack<Int>()
        myIntStack.push(111)
        myIntStack.push(22)
        myIntStack.push(3)
        let poppedInt = myIntStack.pop()
        XCTAssertTrue(myIntStack.length() == 2, "Topmost item is actually removed")
        XCTAssertTrue(myIntStack.items[1] == 22, "Second item now on top")
    }
    
    func testPoppingReturnsNoValueWhenStackIsEmpty() {
        var myIntStack = PushStack<Int>()
        myIntStack.push(111)
        let poppedInt1:Int? = myIntStack.pop()
        XCTAssertTrue(poppedInt1 == 111, "Last item is removed")
        XCTAssertTrue(myIntStack.length() == 0, "It's empty")
        let poppedInt2:Int? = myIntStack.pop()
        XCTAssertTrue(poppedInt2 == nil, "Nothing left on the stack")
    }
}


