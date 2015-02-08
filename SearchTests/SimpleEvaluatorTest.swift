//
//  SimpleEvaluatorTest.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 2/8/15.
//  Copyright (c) 2015 Bill Tozier. All rights reserved.
//

import Cocoa
import XCTest
import PushInterpreter

class PushLengthScenarioTest: XCTestCase {
    
    // A Scenario which just inspects the script without running anything


    func testLengthCountScenarioReturnsValue() {
        let a1 = PushAnswer(length: 11, commands: ["x", "y"], otherTokens: [], commandRatio: 1.0)
        let length_evaluator = PushLengthScenario()
        XCTAssertTrue(length_evaluator.score(a1) == 11.0,"unexpected number of tokens in \(a1.script)")
    }
    
    func testLengthCountShouldWriteToAnswerScores() {
        var a1 = PushAnswer(length: 6, commands: ["x", "y"], otherTokens: [], commandRatio: 1.0)
        let length_evaluator = PushLengthScenario()
        length_evaluator.score(a1)
        XCTAssertTrue(a1.scores[length_evaluator.uniqueID]! == 6.0, "expected score to be 6.0  not \(a1.scores[length_evaluator.uniqueID])")
    }
    
    func testLengthCountShouldNotOverwriteItself() {
        var a1 = PushAnswer(length: 6, commands: ["x", "y"], otherTokens: [], commandRatio: 1.0)
        let length_evaluator = PushLengthScenario()
        a1.scores[length_evaluator.uniqueID] = 99.99
        length_evaluator.score(a1)
        XCTAssertTrue(a1.scores[length_evaluator.uniqueID]! == 99.99, "expected score to be 99.99  not \(a1.scores[length_evaluator.uniqueID]!)")
    }


}
