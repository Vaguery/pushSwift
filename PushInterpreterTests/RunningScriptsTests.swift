//
//  RunningScriptsTests.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/11/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import XCTest
import PushInterpreter

class RunningScriptsTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testReset() {
        let s = "1 F 2.3 T foo 4.5 -9.9 6 F F T bar baz zotz"
        var pi = PushInterpreter()
        let raw = pi.parse(s)
        XCTAssertTrue(raw.count == 14, "Failed to parse script")
        
        let local = PushPoint.Block(raw)
        XCTAssertTrue(local.subtree()!.count == 14, "Something weird")
        
        XCTAssertTrue(pi.program.isBlock(), "Did not clear the program correctly")
        XCTAssertTrue(pi.program.subtree()!.count == 0, "Did not clear the program as an empty Block point")
        
        pi.program = PushPoint.Block(pi.parse(s))
        
        XCTAssertTrue(pi.program.isBlock(), "Did not stage the program correctly")
        XCTAssertTrue(pi.program.subtree()!.count == 14, "Did not stage the program with the right points")

        pi.stage(s)
        
        XCTAssertTrue(pi.program.isBlock(), "Did not stage the program correctly")
        XCTAssertTrue(pi.program.subtree()!.count == 14, "Did not stage the program with the right points")
    }
    

    func testFirstStepUnpacksInitialBlock() {
        let s = "1 2 4 8"
        var pi = PushInterpreter()
        pi.resetWithScript(s)
        XCTAssertTrue(pi.execStack.length() == 1, "Failed to parse script")
        let points = pi.execStack.items[0].subtree()
        XCTAssertTrue(points!.count == 4, "Did not parse script initially")
        pi.step()
        XCTAssertTrue(pi.execStack.length() == 4, "Failed to break up Block")
        XCTAssertTrue(pi.execStack.description == "[ 8 4 2 1 ]", "Didn't expect exec stack to be \(pi.execStack.description)")
    }
    
    func testSimpleScriptsJustFileStuff() {
        let s = "1 F 2.25 T foo 4.5 -9.75 6 F F T bar"
        var pi = PushInterpreter(script: s)
        pi.run()
        
        XCTAssertTrue(pi.execStack.length() == 0, "Did not exhaust exec stack")
        XCTAssertTrue(pi.intStack.length() == 2, "Did not file Ints on stack")
        XCTAssertTrue(pi.intStack.description == "[ 1 6 ]", "Didn't expect stack to be \(pi.intStack.description)")
        XCTAssertTrue(pi.nameStack.description == "[ \"foo\" \"bar\" ]", "Didn't expect stack to be \(pi.nameStack.description)")
        XCTAssertTrue(pi.floatStack.description == "[ 2.25 4.5 -9.75 ]", "Didn't expect stack to be \(pi.floatStack.description)")
        XCTAssertTrue(pi.codeStack.description == "[ ]", "Didn't expect stack to be \(pi.codeStack.description)")
        XCTAssertTrue(pi.boolStack.description == "[ F T F F T ]", "Didn't expect stack to be \(pi.boolStack.description)")

    }
}
