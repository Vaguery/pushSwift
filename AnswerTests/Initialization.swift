//
//  AnswerTests.swift
//  PushSearchTests
//
//  Created by Bill Tozier on 6/15/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import XCTest
import PushInterpreter

class AnswerInitializationTests: XCTestCase {
    
    // initialization
    
    func test_answerInitWithNoFrills() {
        let a1 = PushAnswer(length: 3, commands: ["x"], otherTokens: [], commandRatio: 1.0)
        XCTAssertTrue(a1.script == "x x x ", "didn't expect script to be \(a1.script)")
        XCTAssertTrue(a1.template == ["x", "x", "x"], "didn't expect template to be \(a1.template)")
    }
    
    func test_answerInitializedWithAuniqueID() {
        let a1 = PushAnswer(length: 3, commands: ["x"], otherTokens: [], commandRatio: 1.0)
        XCTAssertNotNil(a1.uniqueID.UUIDString, "uniqueID should not have been nil")
        let a2 = PushAnswer(length: 3, commands: ["x"], otherTokens: [], commandRatio: 1.0)
        XCTAssertFalse(a1.uniqueID == a2.uniqueID, "expected uniqueIDs to be different")
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
    
    func test_defaultTokenListComesFromPushInterpreter() {
        let a1 = PushAnswer(length:10)
        XCTAssertTrue(a1.myInstructions == a1.myInterpreter.activePushInstructions, "didn't expect instructions to be \(a1.myInstructions)")
    }
    
    func test_defaultTokensCanBeOverridden() {
        let a1 = PushAnswer(length:10,commands:["foo"],otherTokens:["x"])
        let remainingTokens = a1.template.filter { $0 != "foo" && $0  != "x" }
        XCTAssertTrue(remainingTokens.count == 0, "didn't expect to find \(remainingTokens)")
    }
    
    func test_defaultRatioBeOverridden() {
        let a1 = PushAnswer(length:10,commands:["foo"],otherTokens:["x"],commandRatio:0.0)
        let nonXtokens = a1.template.filter { $0  != "x" }
        XCTAssertTrue(nonXtokens.count == 0, "didn't expect tokens to be \(a1.template)")
    }
    
}
