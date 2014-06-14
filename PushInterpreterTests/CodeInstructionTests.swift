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

    func test_CodeIsAtom() {
        let myPI = PushInterpreter(script:"code_isAtom code_isAtom")
        myPI.codeStack.push(PushPoint.Block([PushPoint.Integer(1)]))
        myPI.codeStack.push(PushPoint.Block([PushPoint.Integer(2),PushPoint.Integer(2)]))

        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    func test_CodeIsEmpty() {
        let myPI = PushInterpreter(script:"code_isEmpty code_isEmpty")
        myPI.codeStack.push(PushPoint.Block([]))
        myPI.codeStack.push(PushPoint.Block([PushPoint.Integer(2)]))
        
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    func test_CodeQuote() {
        let myPI = PushInterpreter(script:"1 code_quote 2 code_quote ( 3 4 )")
        myPI.run()
        XCTAssertTrue(myPI.codeStack.description == "[ ( 2 ) ( 3 4 ) ]", "Didn't expect stack to be \(myPI.codeStack.description)")
    }
    
    func test_CodeRotate() {
        let myPI = PushInterpreter(script:"code_quote 1 code_quote 2 code_quote ( 3 4 ) code_rotate")
        myPI.run()
        XCTAssertTrue(myPI.codeStack.description == "[ ( 2 ) ( 3 4 ) ( 1 ) ]", "Didn't expect stack to be \(myPI.codeStack.description)")
    }


}
