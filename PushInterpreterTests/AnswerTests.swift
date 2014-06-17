//
//  AnswerTests.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/15/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import XCTest
import PushInterpreter

class AnswerTests: XCTestCase {
    
    // initialization
    
    func test_answerInitWithNoFrills() {
        let a1 = PushAnswer(length: 3, commands: ["x"], otherTokens: [], commandRatio: 1.0)
        XCTAssertTrue(a1.script == "x x x ", "didn't expect script to be \(a1.script)")
        XCTAssertTrue(a1.template == ["x", "x", "x"], "didn't expect template to be \(a1.template)")
    }
    
    func test_answerUsesOtherTokensListToo() {
        let a1 = PushAnswer(length: 4, commands: ["a", "b"], otherTokens: ["x"], commandRatio: 0.0)
        XCTAssertTrue(a1.template == ["x", "x", "x", "x"], "didn't expect template to be \(a1.template)")
    }

    func test_answerAssociatesValuesWithIntegerERCtokens() {
        let a1 = PushAnswer(length: 4, commands: [], otherTokens: ["«int»"], commandRatio: 0.0)
        XCTAssertTrue(a1.literals.count == 4, "didn't expect literals to be \(a1.literals)")
    }
    
    func test_answerAssociatesValuesWithBooleanERCtokens() {
        let a1 = PushAnswer(length: 4, commands: [], otherTokens: ["«bool»"], commandRatio: 0.0)
        XCTAssertTrue(a1.literals.count == 4, "didn't expect literals to be \(a1.literals)")
    }
    
    func test_answerAssociatesValuesWithFloatERCtokens() {
        let a1 = PushAnswer(length: 4, commands: [], otherTokens: ["«float»"], commandRatio: 0.0)
        XCTAssertTrue(a1.literals.count == 4, "didn't expect literals to be \(a1.literals)")
    }

    func test_answerInsertsParentheses() {
        let a1 = PushAnswer(length: 20, commands: [], otherTokens: ["(",")"], commandRatio: 0.0)
        XCTAssertTrue(a1.template.count == 20, "didn't expect tokens to be \(a1.template)")
    }
    
    // TODO: These need to be better tests of what's being checked
    func test_defaultTokenListComesFromPushInterpreter() {
        let a1 = PushAnswer(length:10)
        XCTAssertTrue(a1.template.count == 10, "didn't expect tokens to be \(a1.template)")
    }
    
    func test_defaultTokensCanBeOverridden() {
        let a1 = PushAnswer(length:10,commands:["foo"],otherTokens:["x"])
        XCTAssertTrue(a1.template.count == 10, "didn't expect tokens to be \(a1.template)")
    }
    
    func test_defaultRatioBeOverridden() {
        let a1 = PushAnswer(length:10,commands:["foo"],otherTokens:["x"],commandRatio:0.0)
        XCTAssertTrue(a1.template.count == 10, "didn't expect tokens to be \(a1.template)")
    }


}
