//
//  NameInstructionTests.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/13/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import XCTest
import PushInterpreter

class NameInstructionTests: XCTestCase {
    
    func test_NameArchive() {
        let myPI = PushInterpreter(script:"a name_archive b c")
        myPI.run()
        XCTAssertTrue(myPI.nameStack.description == "[ \"b\" \"c\" \"a\" ]", "Didn't expect stack to be \(myPI.nameStack.description)")
    }

    
    func test_NameDepth() {
        let myPI = PushInterpreter(script:"foo bar name_depth")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 2 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }


    func test_NameDup() {
        let myPI = PushInterpreter(script:"foo bar name_dup")
        myPI.run()
        XCTAssertTrue(myPI.nameStack.description == "[ \"foo\" \"bar\" \"bar\" ]", "Didn't expect stack to be \(myPI.nameStack.description)")
    }
    
    func test_NameFlip() {
        let myPI = PushInterpreter(script:"a b c d name_flip")
        myPI.run()
        XCTAssertTrue(myPI.nameStack.description == "[ \"d\" \"c\" \"b\" \"a\" ]", "Didn't expect stack to be \(myPI.nameStack.description)")
    }

    
    func test_NameFlush() {
        let myPI = PushInterpreter(script:"foo bar name_flush baz")
        myPI.run()
        XCTAssertTrue(myPI.nameStack.description == "[ \"baz\" ]", "Didn't expect stack to be \(myPI.nameStack.description)")
    }

    func test_NameIsAssigned() {
        let myPI = PushInterpreter(script:"x name_isAssigned foo name_isAssigned")
        myPI.bindings["x"] = PushPoint.Boolean(true)
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }

    
    func test_NameIsEqual() {
        let myPI = PushInterpreter(script:"foo bar name_isEqual baz baz name_isEqual")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    
    func test_NameNew() {
        let myPI = PushInterpreter(script:"foo name_new bar")
        myPI.run()
        XCTAssertTrue(myPI.nameStack.length() == 3, "Didn't expect stack to be \(myPI.nameStack.description)")
        let newName = myPI.nameStack.items[1].value as String
        XCTAssertTrue(countElements(newName) > 20, "New name \(newName) doesn't seem right somehow")
    }

    
    func test_NamePop() {
        let myPI = PushInterpreter(script:"foo bar baz name_pop")
        myPI.run()
        XCTAssertTrue(myPI.nameStack.description == "[ \"foo\" \"bar\" ]", "Didn't expect stack to be \(myPI.nameStack.description)")
    }
    
    func test_NameRotate() {
        let myPI = PushInterpreter(script:"foo bar baz name_rotate")
        myPI.run()
        XCTAssertTrue(myPI.nameStack.description == "[ \"bar\" \"baz\" \"foo\" ]", "Didn't expect stack to be \(myPI.nameStack.description)")
    }
    
    func test_NameShove() {
        let myPI = PushInterpreter(script:"a b c d e 2 name_shove ")
        myPI.run()
        XCTAssertTrue(myPI.nameStack.description == "[ \"a\" \"b\" \"e\" \"c\" \"d\" ]", "Didn't expect stack to be \(myPI.nameStack.description)")
    }


    func test_NameSwap() {
        let myPI = PushInterpreter(script:"foo bar baz name_swap")
        myPI.run()
        XCTAssertTrue(myPI.nameStack.description == "[ \"foo\" \"baz\" \"bar\" ]", "Didn't expect stack to be \(myPI.nameStack.description)")
    }

    func test_NameYank() {
        let myPI = PushInterpreter(script:"a b c d e -22 name_yank")
        myPI.run()
        XCTAssertTrue(myPI.nameStack.description == "[ \"a\" \"b\" \"c\" \"e\" \"d\" ]", "Didn't expect stack to be \(myPI.nameStack.description)")
    }
    
    
    func test_NameYankDup() {
        let myPI = PushInterpreter(script:"a b c d e -22 name_yankDup")
        myPI.run()
        XCTAssertTrue(myPI.nameStack.description == "[ \"a\" \"b\" \"c\" \"d\" \"e\" \"d\" ]", "Didn't expect stack to be \(myPI.nameStack.description)")
    }


}
