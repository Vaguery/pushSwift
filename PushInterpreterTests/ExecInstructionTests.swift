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

    func testExecIsLiteral() {
        let myPI = PushInterpreter(script:"exec_isLiteral 4 exec_isLiteral ( 4 )")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }

    
    func testExecIsBlock() {
        let myPI = PushInterpreter(script:"exec_isBlock 4 exec_isBlock ( 4 )")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
}
