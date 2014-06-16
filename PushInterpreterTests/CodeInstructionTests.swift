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
    
    func test_CodeAppend() {
        let myPI = PushInterpreter(script:"code_quote ( 1 2 ) code_quote foo code_append")
        myPI.run()
        XCTAssertTrue(myPI.codeStack.description == "[ ( ( 1 2 ) ( \"foo\" ) ) ]", "Didn't expect stack to be \(myPI.codeStack.description)")
    }
    
    
    func test_CodeArchive() {
        let myPI = PushInterpreter(script:"code_quote F code_archive code_quote 2 code_quote 3")
        myPI.run()
        XCTAssertTrue(myPI.codeStack.description == "[ ( 2 ) ( 3 ) ]", "Didn't expect stack to be \(myPI.codeStack.description)")
        XCTAssertTrue(myPI.boolStack.description == "[ F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }

    
    func test_CodeCar() {
        let myPI = PushInterpreter(script:"code_quote F code_car code_quote ( 2 3 ) code_car")
        myPI.run()
        XCTAssertTrue(myPI.codeStack.description == "[ ( 2 ) ]", "Didn't expect stack to be \(myPI.codeStack.description)")
    }
    
    func test_CodeCdr() {
        let myPI = PushInterpreter(script:"code_quote F code_cdr code_quote ( 1 2 3 ) code_cdr")
        myPI.run()
        XCTAssertTrue(myPI.codeStack.description == "[ ( 2 3 ) ]", "Didn't expect stack to be \(myPI.codeStack.description)")
    }
    
    func test_CodeCons() {
        let myPI = PushInterpreter(script:"code_quote F code_quote ( 1 2 3 ) code_cons")
        myPI.run()
        XCTAssertTrue(myPI.codeStack.description == "[ ( ( 1 2 3 ) F ) ]", "Didn't expect stack to be \(myPI.codeStack.description)")
    }


    
    func test_CodeDefine() {
        let myPI = PushInterpreter(script:"foo code_quote bar code_define foo foo foo")
        myPI.run()
        XCTAssertTrue(myPI.bindings.count > 0, "Expected \(myPI.bindings) to include foo")
        XCTAssertTrue(myPI.nameStack.description == "[ \"bar\" \"bar\" \"bar\" ]", "Didn't expect stack to be \(myPI.nameStack.description)")
    }

    
    func test_CodeDepth() {
        let myPI = PushInterpreter(script:"code_quote 1 code_depth")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 1 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    
    func test_CodeDup() {
        let myPI = PushInterpreter(script:"code_quote 1 code_dup")
        myPI.run()
        XCTAssertTrue(myPI.codeStack.description == "[ ( 1 ) ( 1 ) ]", "Didn't expect stack to be \(myPI.codeStack.description)")
    }
    
    
    func test_CodeFlip() {
        let myPI = PushInterpreter(script:"code_quote 1 code_quote 2 code_quote 3 code_flip")
        myPI.run()
        XCTAssertTrue(myPI.codeStack.description == "[ ( 3 ) ( 2 ) ( 1 ) ]", "Didn't expect stack to be \(myPI.codeStack.description)")
    }
    
    func test_CodeFlush() {
        let myPI = PushInterpreter(script:"code_quote 1 code_quote 2 code_flush code_quote 3")
        myPI.run()
        XCTAssertTrue(myPI.codeStack.description == "[ ( 3 ) ]", "Didn't expect stack to be \(myPI.codeStack.description)")
    }
    
    func test_CodeFromAllTheThings() {
        let myPI = PushInterpreter(script:"3.5 code_fromFloat F code_fromBool -10 code_fromInt foo code_fromName 4 9 range_fromInts code_fromRange")
        myPI.run()
        XCTAssertTrue(myPI.codeStack.description == "[ ( 3.5 ) ( F ) ( -10 ) ( \"foo\" ) ( (4..9) ) ]", "Didn't expect stack to be \(myPI.codeStack.description)")
    }


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
    
    func test_CodeIsEqual() {
        let myPI = PushInterpreter(script:"code_quote ( 1 2 ) code_quote ( 1 2 ) code_isEqual code_quote ( 1 ( 2 ) ) code_quote ( ( 1 ) 2 ) code_isEqual")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    func test_CodeLength() {
        let myPI = PushInterpreter(script:"code_quote ( 1 2 ) code_length code_quote ( 1 ) code_length code_quote ( ( 1 2 ) ( 3 4 ( 5 ) ) ) code_length code_quote ( ) code_length")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 2 1 2 0 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }


    
    func test_CodePop() {
        let myPI = PushInterpreter(script:"code_quote 2 code_quote ( 3 4 ) code_pop")
        myPI.run()
        XCTAssertTrue(myPI.codeStack.description == "[ ( 2 ) ]", "Didn't expect stack to be \(myPI.codeStack.description)")
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
    
    func test_CodeShove() {
        let myPI = PushInterpreter(script:"-2 code_quote 1 code_quote 2 code_quote F code_shove")
        myPI.run()
        XCTAssertTrue(myPI.codeStack.description == "[ ( 1 ) ( F ) ( 2 ) ]", "Didn't expect stack to be \(myPI.codeStack.description)")
    }

    
    
    func test_CodeSwap() {
        let myPI = PushInterpreter(script:"code_quote 1 code_quote 2 code_swap")
        myPI.run()
        XCTAssertTrue(myPI.codeStack.description == "[ ( 2 ) ( 1 ) ]", "Didn't expect stack to be \(myPI.codeStack.description)")

    }


}
