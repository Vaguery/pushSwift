//
//  ExecInstructionTests.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/13/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import XCTest
import PushInterpreter

class ExecInstructionTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_ExecArchive() {
        let myPI = PushInterpreter(script:"exec_archive F T T T")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T T T F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    
    func test_ExecCountWithRange() {
        let myPI = PushInterpreter(script:"3 range_fromZero exec_countWithRange F 9 9 range_fromInts exec_countWithRange T")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F F F F T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
        XCTAssertTrue(myPI.intStack.description == "[ 0 1 2 3 9 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }


    
    func test_ExecDefine() {
        let myPI = PushInterpreter(script:"foo exec_define 44 foo foo foo")
        myPI.run()
        XCTAssertTrue(myPI.bindings.count > 0, "Expected \(myPI.bindings) to include foo")
        XCTAssertTrue(myPI.intStack.description == "[ 44 44 44 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    
    func test_ExecDepth() {
        let myPI = PushInterpreter(script:"exec_depth 1 2 3 4")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 4 1 2 3 4 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    
    func test_ExecDup() {
        let myPI = PushInterpreter(script:"exec_dup T")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    func test_ExecEqual() {
        let myPI = PushInterpreter(script:"exec_equal T T exec_equal ( ( 1 2 ) 3 ) ( ( 1 2 ) 3 ) exec_equal ( ( 1 2 ) 3 ) ( ( ( 1 ) 2 ) 3 )")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T T F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }

    
    
    func test_ExecFlip() {
        let myPI = PushInterpreter(script:"exec_flip 1 2 3 4")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 4 3 2 1 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    
    func test_ExecFlush() {
        let myPI = PushInterpreter(script:" 1 2 exec_flush 3 4")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 1 2 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }
    
    func test_ExecIf() {
        let myPI = PushInterpreter(script:" F exec_if 1 2 T exec_if 3 4")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 1 4 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    
    func test_ExecIsBlock() {
        let myPI = PushInterpreter(script:"exec_isBlock 4 exec_isBlock ( 4 )")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    func test_ExecK() {
        let myPI = PushInterpreter(script:"exec_k 1 2 3 4 5")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 1 3 4 5 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }
    
    func test_ExecIsLiteral() {
        let myPI = PushInterpreter(script:"exec_isLiteral 4 exec_isLiteral ( 4 )")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    func test_ExecPop() {
        let myPI = PushInterpreter(script:"T exec_pop F T")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    func test_ExecRotate() {
        let myPI = PushInterpreter(script:"exec_rotate 1 2 3 4")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 3 1 2 4 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }
    
    func test_ExecS() {
        let myPI = PushInterpreter(script:"exec_s 1 2 3 4 5")
        myPI.step()  // unwraps program
        myPI.step()
        XCTAssertTrue(myPI.execStack.description == "[ 5 4 ( 2 3 ) 3 1 ]", "Didn't expect stack to be \(myPI.execStack.description)")
    }

    
    func test_ExecShove() {
        let myPI = PushInterpreter(script:"3 exec_shove 1 2 3 4 5 6")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 2 3 1 4 5 6 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }


    func test_ExecSwap() {
        let myPI = PushInterpreter(script:"exec_swap 1 2 3 4")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 2 1 3 4 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }
    
    func test_ExecY() {
        let myPI = PushInterpreter(script:"1 2 exec_y 3 4")
        myPI.stepLimit = 20
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 1 2 3 3 3 3 3 3 ]", "Didn't expect stack to be \(myPI.intStack.description)")
        XCTAssertTrue(myPI.execStack.description == "[ 4 3 :exec_y ]", "Didn't expect stack to be \(myPI.execStack.description)")
    }

    
    func test_ExecYank() {
        let myPI = PushInterpreter(script:"2 exec_yank 1 2 3 4 5 6 7")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 5 1 2 3 4 6 7 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }
    
    
    func test_ExecYankDup() {
        let myPI = PushInterpreter(script:"2 exec_yankDup 1 2 3 4 5 6 7")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 5 1 2 3 4 5 6 7 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }


}
