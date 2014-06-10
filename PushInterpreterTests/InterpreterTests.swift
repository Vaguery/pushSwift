//
//  InterpreterTests.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/7/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import XCTest
import PushInterpreter

class InterpreterTests: XCTestCase {

    func testNewInterpreterHasStandardStacks() {
        var myInterpreter = PushInterpreter()
        XCTAssertTrue(myInterpreter.intStack.length()   == 0, "intStack not empty")
        XCTAssertTrue(myInterpreter.boolStack.length()  == 0, "boolStack not empty")
        XCTAssertTrue(myInterpreter.floatStack.length() == 0, "floatStack not empty")
        XCTAssertTrue(myInterpreter.nameStack.length()  == 0, "nameStack not empty")
        XCTAssertTrue(myInterpreter.codeStack.length()  == 0, "codeStack not empty")
        XCTAssertTrue(myInterpreter.execStack.length()  == 0, "execStack not empty")
    }
}
