//
//  PushParserTests.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/6/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import XCTest
import PushInterpreter

class PushParserTests: XCTestCase {

    func testParserSplitsScriptOnWhitespace() {
        var myInterpreter = PushInterpreter()
        let parsedPoints = myInterpreter.parse( "F T" )
        XCTAssertTrue(parsedPoints.count == 2, "All tokens were not saved")
        XCTAssertTrue(parsedPoints[0].value as Bool == false, "Script parsing missed a token")
        XCTAssertTrue(parsedPoints[1].value as Bool == true, "Script parsing missed a token")
    }
    
    func testParserSkipsMultipleWhitespace() {
        var myInterpreter = PushInterpreter()
        let parsedPoints = myInterpreter.parse( "  foo   bar  " )
        XCTAssertTrue(parsedPoints.count == 2, "Wrong number of tokens captured")
        XCTAssertTrue(parsedPoints[0].value as String == "foo", "Script parsing missed a token")
        XCTAssertTrue(parsedPoints[1].value as String == "bar", "Script parsing missed a token")
    }

    func testParserSkipsTabsNewlinesAndAllWhitespace() {
        var myParser = PushInterpreter()
        let parsedPoints = myParser.parse( "  \tfoo \n\n  bar  " )
        XCTAssertTrue(parsedPoints.count == 2, "Wrong number of tokens captured")
        XCTAssertTrue(parsedPoints[0].value as String == "foo", "Script parsing missed a token")
        XCTAssertTrue(parsedPoints[1].value as String == "bar", "Script parsing missed a token")
    }
    
    func testParserCatchesTokensExpectedToBeInPushScripts() {
        var myParser = PushInterpreter()
        let parsedPoints = myParser.parse( "3 -22.3 F bool.and int.dup ) bool.not emit.x" )
        XCTAssertTrue(parsedPoints.count == 8, "Wrong number of tokens captured")
    }
    
    // can we match Integers?
    
    func testMatcherRecognizesIntegerTokens() {
        var myInterpreter = PushInterpreter()
        let tokens = ["771", "0", "-99", "+8888"]
        for t in tokens {
            var myPoint:PushPoint = myInterpreter.programPointFromToken(t)
            XCTAssertTrue(myPoint.value as Int == t.toInt()!, "did not work on \(t)")
        }
    }
    
    func testMatcherSkipsBadIntegerTokens() {
        var myInterpreter = PushInterpreter()
        let tokens = ["771a", "0a", "-9.9.9", "++8888", "9 9 9"]
        for t in tokens {
            var myPoint:PushPoint = myInterpreter.programPointFromToken(t)
            XCTAssertFalse(myPoint.isInteger(), "did not work on \(t)")
        }
    }
    
    // can we match Floats?
    
    func testMatcherRecognizesFloatTokens() {
        var myInterpreter = PushInterpreter()
        let tokens = ["771.1", "0.0", "-.99", "+.8888", "4.2e4", "-.1e8"]
        for t in tokens {
            var myPoint:PushPoint = myInterpreter.programPointFromToken(t)
            let f:Double = myPoint.value as Double
            let correct_number = t.bridgeToObjectiveC().floatValue
            XCTAssertNotNil(f as? Double, "Should have returned a PushPoint.Float")
            XCTAssertTrue(f == correct_number, "Float literal somehow changed while being parsed")
        }
    }
    
    func testMatcherCreatesNamesFromUnrecognizedTokens() {
        var myInterpreter = PushInterpreter()
        let tokens = ["771a", "0a", "-9.9.9", "++8888", "9 9 9", "foo&&!"]
        for t in tokens {
            var myPoint:PushPoint = myInterpreter.programPointFromToken(t)
            XCTAssertTrue(myPoint.isName(), "should not have recognized token \(t)")
        }
    }
    
    func testMatcherCreatesInstructionsFromRecognizedTokens() {
        var myInterpreter = PushInterpreter()
        for instruction in myInterpreter.listOfPushInstructions {
            var myPoint = myInterpreter.programPointFromToken(instruction)
            XCTAssertTrue(contains(myInterpreter.listOfPushInstructions, myPoint.value as String), "Failed to recognize \(instruction) as an instruction name")
        }
    }


    
//    // making sure it's recognizing core types
//    
//    func testParserCatchesBooleans() {
//        var myParser = PushInterpreter()
//        let parsedPoints = myParser.parse("F F F T T F")
//        XCTAssertTrue(parsedPoints.count == 6, "Wrong number of tokens captured")
//        for item in parsedPoints {
//            XCTAssertTrue(item.isBoolean(), "Not parsed correctly")
//        }
//    }
//    
//    
//    
//    func testParserCatchesIntegers() {
//        var myParser = PushInterpreter()
//        let parsedPoints = myParser.parse("12 -12 0 -0 999999 -0009991")
//        XCTAssertTrue(parsedPoints.count == 6, "Wrong number of tokens captured")
//        for item in parsedPoints {
//            XCTAssertTrue(item.isInteger(), "Not parsed correctly")
//        }
//    }
}
