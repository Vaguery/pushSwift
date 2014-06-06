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
        var myParser = PushParser()
        myParser.parseScript( "foo bar" )
        XCTAssertTrue(myParser.tokens.count == 2, "All tokens were not saved")
        XCTAssertTrue(myParser.tokens[0] == "foo", "Script parsing missed a token")
        XCTAssertTrue(myParser.tokens[1] == "bar", "Script parsing missed a token")
    }
    
    func testParserSkipsMultipleWhitespace() {
        var myParser = PushParser()
        myParser.parseScript( "  foo   bar  " )
        XCTAssertTrue(myParser.tokens.count == 2, "Wrong number of tokens captured")
        XCTAssertTrue(myParser.tokens[0] == "foo", "Script parsing missed a token")
        XCTAssertTrue(myParser.tokens[1] == "bar", "Script parsing missed a token")
    }
    
    func testParserSkipsTabsNewlinesAndAllWhitespace() {
        var myParser = PushParser()
        myParser.parseScript( "  \tfoo \n\n  bar  " )
        XCTAssertTrue(myParser.tokens.count == 2, "Wrong number of tokens captured")
        XCTAssertTrue(myParser.tokens[0] == "foo", "Script parsing missed a token")
        XCTAssertTrue(myParser.tokens[1] == "bar", "Script parsing missed a token")
    }
    
    func testParserCatchesTokensExpectedToBeInPushScripts() {
        var myParser = PushParser()
        myParser.parseScript( "3 -22.3 F bool.and int.dup ) bool.not emit.x" )
        XCTAssertTrue(myParser.tokens.count == 8, "Wrong number of tokens captured")
    }
}
