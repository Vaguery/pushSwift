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
        XCTAssertTrue(parsedPoints.count == 7, "Wrong number of tokens captured")
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
        for instruction in myInterpreter.activePushInstructions {
            var myPoint = myInterpreter.programPointFromToken(instruction)
            XCTAssertTrue(contains(myInterpreter.activePushInstructions, myPoint.value as String), "Failed to recognize \(instruction) as an instruction name")
        }
    }
    
    
    func testBlockCaptureWorksInSimpleCases() {
        var myInterpreter = PushInterpreter()
        var tokenList = ["1", "2", "3"]
        let pts = myInterpreter.pointsFromTokenArray(&tokenList)
        XCTAssertTrue(pts.count == 3, "Missed some tokens")
        let nums = pts.map({pt in pt.value as Int})
        XCTAssert(nums == [1,2,3],"Parser captured values incorrectly")
    }
    
    
    func testBlockCaptureWorksForEmptyBlocks() {
        var myInterpreter = PushInterpreter()
        var tokenList = ["(", ")"]
        let pts = myInterpreter.pointsFromTokenArray(&tokenList)
        XCTAssertTrue(pts.count == 1, "Missed some tokens")
        XCTAssertTrue(pts[0].isBlock(), "parser did not build \(tokenList)")
        XCTAssert(pts[0].subtree()!.count == 0, "Parser did not build block")
        
        XCTAssertTrue(pts.description == "[( )]", "Got \(pts.description) instead")
    }
    
    
    func testBlockCaptureSkipsExtraCloseParens() {
        var myInterpreter = PushInterpreter()
        var tokenList = ["1", ")", "(", ")", ")"]
        let pts = myInterpreter.pointsFromTokenArray(&tokenList)
        XCTAssertTrue(pts.count == 2, "Didn't create the right number of tokens")
        XCTAssertTrue(pts[0].isInteger(), "parser did not build \(tokenList)")
        XCTAssertTrue(pts[1].isBlock(), "parser did not build \(tokenList)")
        
        XCTAssertTrue(pts.description == "[1, ( )]", "Got \(pts.description) instead")
    }

    
    func testBlockAutoClosesMissingCloseParens() {
        var myInterpreter = PushInterpreter()
        var tokenList = ["(", "(", "(", "1", ")"]
        let pts = myInterpreter.pointsFromTokenArray(&tokenList)
        XCTAssertTrue(pts.count == 1, "Parser didn't create the right number of tokens")
        XCTAssertTrue(pts[0].isBlock(), "parser did not build \(tokenList)")
        XCTAssertTrue(pts[0].subtree()!.count == 1, "Parser didn't nest tree correctly")
        let num = pts[0].subtree()![0].subtree()![0].subtree()![0]
        XCTAssertTrue(num.isInteger(), "Parser didn't capture values correctly")
        
        XCTAssertTrue(pts.description == "[( ( ( 1 ) ) )]", "Got \(pts.description) instead")

    }
    
    
    func testBlockCaptureGetsBranches() {
        var myInterpreter = PushInterpreter()
        var tokenList = ["(", "1", ")", "(", "2", ")","(", "3", ")"]
        let pts = myInterpreter.pointsFromTokenArray(&tokenList)
        XCTAssertTrue(pts.description == "[( 1 ), ( 2 ), ( 3 )]", "Got \(pts.description) instead")
    }
}