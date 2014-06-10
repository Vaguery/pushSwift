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
    
    // making sure it's recognizing core types
    
    func testParserCatchesBooleans() {
        var myParser = PushInterpreter()
        let parsedPoints = myParser.parse("F F F T T F")
        XCTAssertTrue(parsedPoints.count == 6, "Wrong number of tokens captured")
        for item in parsedPoints {
            XCTAssertTrue(item.isBoolean(), "Not parsed correctly")
        }
    }
}
