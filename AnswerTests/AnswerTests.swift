//
//  AnswerTests.swift
//  AnswerTests
//
//  Created by Bill Tozier on 2/8/15.
//  Copyright (c) 2015 Bill Tozier. All rights reserved.
//

import Cocoa
import XCTest
import PushInterpreter

class AnswerTests: XCTestCase {
    
    // methods to set up and run the script in the interpreter
    
    
    
    func test_answerInterpreterCanBeReset() {
        var a1 = PushAnswer(length: 5, commands: ["1"], otherTokens: [], commandRatio: 1.0)
        a1.reset()
        XCTAssertTrue(a1.interpreter.steps == 0,"got \(a1.interpreter.steps)")
        XCTAssertTrue(a1.interpreter.script == "1 1 1 1 1 ","got \(a1.interpreter.script)")
    }
    
    func test_answerInterpreterCanBeResetWithNewBindings() {
        var a1 = PushAnswer(length: 2, commands: ["x"], otherTokens: [], commandRatio: 1.0)
        a1.resetWithBindings(["x":"88 99"])
        XCTAssertTrue(a1.interpreter.steps == 0,"got \(a1.interpreter.steps)")
        XCTAssertTrue(a1.interpreter.script == "x x ","got \(a1.interpreter.script)")
        let whatXis = a1.interpreter.bindings["x"]!
        XCTAssertTrue(whatXis.description == "( 88 99 )","got \(whatXis)")
    }
    
    func test_answerInterpreterCanBeRun() {
        var a1 = PushAnswer(length: 5, commands: ["x"], otherTokens: [], commandRatio: 1.0)
        a1.resetWithBindings(["x":"F"])
        a1.run()
        XCTAssertTrue(a1.interpreter.boolStack.description == "[ F F F F F ]","got \(a1.interpreter.boolStack.description)")
    }
}
