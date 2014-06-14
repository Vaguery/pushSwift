//
//  RangeInstructionTests.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/13/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import XCTest
import PushInterpreter

class RangeInstructionTests: XCTestCase {
    // for the moment, Range points cannot be parsed from scripts
    
    func test_RangeFromInts() {
        let myPI = PushInterpreter(script:"-11 11 range_fromInts")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (-11..11) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }
    
    func test_RangeReverse() {
        let myPI = PushInterpreter(script:"-11 11 range_fromInts range_reverse")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (11..-11) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }
    
    func test_RangeRotate() {
        let myPI = PushInterpreter(script:"1 2 range_fromInts 3 4 range_fromInts 5 6 range_fromInts range_rotate")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (3..4) (5..6) (1..2) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }


    
}
