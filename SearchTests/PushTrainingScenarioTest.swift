//
//  PushTrainingScenarioTest.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 2/9/15.
//  Copyright (c) 2015 Bill Tozier. All rights reserved.
//

import Cocoa
import XCTest
import PushInterpreter

class PushStaticTrainingScenarioTest: XCTestCase {

    // A Scenario which sets up bindings, runs the code once, and scores based on interpreter state when done
    
    
    func test_ScenarioSetsUpBindingsRight() {
        var a1 = PushAnswer(length: 1, commands: ["x", "y"], otherTokens: [], commandRatio: 1.0)
        let dummy_score = {(a:PushAnswer) -> Double in return 6.0 }
        let ioScenario = PushStaticTrainingScenario(scenario_bindings:["x":"123","y":"F"],scorer:dummy_score)
        ioScenario.score(a1)
        XCTAssertTrue(a1.myInterpreter.bindings.count == 2,"should be 2 bindings")
        XCTAssertTrue(a1.myInterpreter.bindings["x"]!.description == "( 123 )", "nope")
        XCTAssertTrue(a1.myInterpreter.bindings["y"]!.description == "( F )", "nope")
    }
    
    
    func test_ScenarioActuallyRunsScript() {
        var a1 = PushAnswer(length: 3, commands: ["x"], otherTokens: [], commandRatio: 1.0)
        let dummy_score = {(a:PushAnswer) -> Double in return 6.0 }
        let ioScenario = PushStaticTrainingScenario(scenario_bindings:["x":"123","y":"F"],scorer:dummy_score)
        XCTAssertTrue(a1.myInterpreter.script == "x x x ","script should have been \"\(a1.myInterpreter.script)\"")
        ioScenario.score(a1)
        XCTAssertTrue(a1.myInterpreter.intStack.description == "[ 123 123 123 ]","intStack should be \(a1.myInterpreter.intStack.description)")
    }
    
    
    func test_ScenarioActuallyReturnsTheScore() {
        var a1 = PushAnswer(length: 3, commands: ["x"], otherTokens: [], commandRatio: 1.0)
        let dummy_score = {(a:PushAnswer) -> Double in return 6.0 }
        let ioScenario = PushStaticTrainingScenario(scenario_bindings:["x":"123"],scorer:dummy_score)
        let score = ioScenario.score(a1)
        XCTAssertTrue(a1.myInterpreter.intStack.description == "[ 123 123 123 ]","intStack should be \(a1.myInterpreter.intStack.description)")
        XCTAssertTrue(score == 6.0, "Expected 6.0, got \(score)")
        XCTAssertTrue(a1.scores[ioScenario.uniqueID] == 6.0, "Expected 6.0, got \(score)")
    }
    
    
    func test_MultipleScenariosCreateMultipleScores() {
        var a1 = PushAnswer(length: 3, commands: ["x"], otherTokens: [], commandRatio: 1.0)
        let what_number = {(a:PushAnswer) -> Double in
            let num = a.myInterpreter.intStack.pop()!.value as Int
            return Double(num)
        }
        let threeScenario = PushStaticTrainingScenario(scenario_bindings:["x":"3"],scorer:what_number)
        let minusThreeScenario = PushStaticTrainingScenario(scenario_bindings:["x":"-3"],scorer:what_number)
        var score = threeScenario.score(a1)
        XCTAssertTrue(score == 3.0, "Expected 3.0, got \(score)")
        score = minusThreeScenario.score(a1)
        XCTAssertTrue(score == -3.0, "Expected -3.0, got \(score)")
        XCTAssertTrue(a1.scores.count == 2, "expected 2 scores, got \(a1.scores.count)")
    }

}
