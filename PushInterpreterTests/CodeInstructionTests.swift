//
//  CodeInstructionTests.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/13/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import XCTest
import PushInterpreter

class CodeInstructionTests: XCTestCase {

    func testCodeIsAtom() {
        let myPI = PushInterpreter(script:"code_isAtom code_isAtom")
        myPI.codeStack.push(PushPoint.Block([PushPoint.Integer(1)]))
        myPI.codeStack.push(PushPoint.Block([PushPoint.Integer(2),PushPoint.Integer(2)]))

        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    func testCodeIsEmpty() {
        let myPI = PushInterpreter(script:"code_isEmpty code_isEmpty")
        myPI.codeStack.push(PushPoint.Block([]))
        myPI.codeStack.push(PushPoint.Block([PushPoint.Integer(2)]))
        
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }

}
