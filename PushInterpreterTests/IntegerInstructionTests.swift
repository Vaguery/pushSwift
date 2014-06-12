//
//  IntegerInstructionTests.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/11/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import XCTest
import PushInterpreter

class IntegerInstructionTests: XCTestCase {

    func testIntAdd() {
        let myPI = PushInterpreter(script:"2 3 int_add")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 5 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }
}
