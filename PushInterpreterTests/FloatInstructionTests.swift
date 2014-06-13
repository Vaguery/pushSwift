//
//  FloatInstructionTests.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/13/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import XCTest
import PushInterpreter

class FloatInstructionTests: XCTestCase {
    
    func testFloatAbs() {
        let myPI = PushInterpreter(script:"9.5 float_abs -1.25 float_abs")
        myPI.run()
        XCTAssertTrue(myPI.floatStack.description == "[ 9.5 1.25 ]", "Didn't expect stack to be \(myPI.floatStack.description)")
    }
    
}
