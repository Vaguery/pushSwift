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
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // initialization

    func testNewInterpreterHasStandardStacks() {
        var myInterpreter = PushInterpreter()
        XCTAssertTrue(myInterpreter.intStack.length()   == 0, "intStack not empty")
        XCTAssertTrue(myInterpreter.boolStack.length()  == 0, "boolStack not empty")
        XCTAssertTrue(myInterpreter.floatStack.length() == 0, "floatStack not empty")
        XCTAssertTrue(myInterpreter.nameStack.length()  == 0, "nameStack not empty")
        XCTAssertTrue(myInterpreter.codeStack.length()  == 0, "codeStack not empty")
        XCTAssertTrue(myInterpreter.execStack.length()  == 1, "execStack contains program")
    }
    
    func testNewInterpreterHasEmptyScriptIfNoneProvided() {
        var myPI = PushInterpreter()
        XCTAssertTrue(myPI.script == "", "Should have a script stored")
    }
    
    func testNewInterpreterCanAcceptScript() {
        var myPI = PushInterpreter(script:"3 4 int_add")
        XCTAssertTrue(myPI.script == "3 4 int_add", "Should have a script stored")
    }
    
    func testNewInterpreterHasZeroSteps() {
        var myPI = PushInterpreter()
        XCTAssertTrue(myPI.steps == 0, "Should have a reset counter")
    }
    
    func testNewInterpreterHasNoNameBindings() {
        var myPI = PushInterpreter()
        XCTAssertTrue(myPI.bindings.count == 0, "Should have no bindings to start out with")
    }
    
    func test_convenienceInitializerWithBindings() {
        let myBindings = ["x":PushPoint.Integer(12)]
        var myPI = PushInterpreter(script:"x x int_add",bindings:myBindings)
        XCTAssertTrue(myPI.bindings["x"]!.value as Int == 12, "Didn't expect bindings to be \(myPI.bindings)")
    }
    
    // Name bindings
    
    func testNameDictionary() {
        var myPI = PushInterpreter(script:"x")
        myPI.bind("x",point:PushPoint.Integer(444))
        myPI.run()
        XCTAssertTrue(myPI.bindings.count == 1, "Should have a binding now")
        XCTAssertTrue(myPI.intStack.description == "[ 444 ]", "It should have looked up the bound value")
        XCTAssertTrue(myPI.nameStack.length() == 0, "should not have pushed the name point")
    }
    
}
