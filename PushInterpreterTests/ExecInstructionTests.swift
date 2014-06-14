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
    
    func test_ExecFlush() {
        let myPI = PushInterpreter(script:" 1 2 exec_flush 3 4")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 1 2 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    
    func test_ExecIsBlock() {
        let myPI = PushInterpreter(script:"exec_isBlock 4 exec_isBlock ( 4 )")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
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

    func test_ExecSwap() {
        let myPI = PushInterpreter(script:"exec_swap 1 2 3 4")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 2 1 3 4 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

}
