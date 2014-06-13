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

    func testNameIsAssigned() {
        let myPI = PushInterpreter(script:"x name_isAssigned foo name_isAssigned")
        myPI.bindings["x"] = PushPoint.Boolean(true)
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }

}
