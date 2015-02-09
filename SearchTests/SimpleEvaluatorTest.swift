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

class PushOneTimeScenarioTest: XCTestCase {
    
    
    // A One Time Scenario that accepts a closure argument (PushInterpreter) -> Double
    
    func test_OneTimeScenarioInitializedWithScoreFunction() {
        let a1 = PushAnswer(length: 11, commands: ["x", "y"], otherTokens: [], commandRatio: 1.0)
        let return_six = { (a:PushAnswer) -> Double in
            return 6.0
        }
        let six_evaluator = PushOneTimeScenario(scorer:return_six)
        let should_be_six = six_evaluator.score(a1)
        XCTAssertTrue(should_be_six == 6.0, "expected 6.0, got \(should_be_six)")
        XCTAssertTrue(a1.scores[six_evaluator.uniqueID] == 6.0, "expected 6.0, got \(a1.scores[six_evaluator.uniqueID])")
    }
    
    // Some more reasonable examples: the number of tokens in the template (complexity)
    
    func test_LengthCountScenarioReturnsValue() {
        let a1 = PushAnswer(length: 11, commands: ["x", "y"], otherTokens: [], commandRatio: 1.0)
        let length_evaluator = PushOneTimeScenario() {(a:PushAnswer) -> Double in
            return Double(a.template.count)
        }
        XCTAssertTrue(length_evaluator.score(a1) == 11.0,"unexpected number of tokens in \(a1.script)")
    }
    
    func test_LengthCountShouldWriteToAnswerScores() {
        var a1 = PushAnswer(length: 6, commands: ["x", "y"], otherTokens: [], commandRatio: 1.0)
        let length_evaluator = PushOneTimeScenario() {(a:PushAnswer) -> Double in
            return Double(a.template.count)
        }
        length_evaluator.score(a1)
        XCTAssertTrue(a1.scores[length_evaluator.uniqueID]! == 6.0, "expected score to be 6.0  not \(a1.scores[length_evaluator.uniqueID])")
    }
    
    func test_LengthCountShouldNotOverwriteItself() {
        var a1 = PushAnswer(length: 6, commands: ["x", "y"], otherTokens: [], commandRatio: 1.0)
        let length_evaluator = PushOneTimeScenario() {(a:PushAnswer) -> Double in
            return Double(a.template.count)
        }
        a1.scores[length_evaluator.uniqueID] = 99.99
        length_evaluator.score(a1)
        XCTAssertTrue(a1.scores[length_evaluator.uniqueID]! == 99.99, "expected score to be 99.99  not \(a1.scores[length_evaluator.uniqueID]!)")
    }

}
