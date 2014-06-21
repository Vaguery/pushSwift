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
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // for the moment, Range points cannot be parsed from scripts
    
    
    func test_RangeArchive() {
        let myPI = PushInterpreter(script:"1 range_fromZero range_archive 2 range_fromZero 3 range_fromZero")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (0..2) (0..3) (0..1) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }
    
    func test_RangeCount() {
        let myPI = PushInterpreter(script:"1 2 range_fromInts range_count 4 -2 range_fromInts range_count 5 5 range_fromInts range_count")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (2..2) (3..-2) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
        XCTAssertTrue(myPI.intStack.description == "[ 1 4 5 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    func test_RangeCountBy() {
        let myPI = PushInterpreter(script:"-5 10 range_fromInts 3 range_countBy 4 -21 range_fromInts -5 range_countBy 5 5 range_fromInts 2 range_countBy 100 110 range_fromInts 200 range_countBy")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (-2..10) (-1..-21) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
        XCTAssertTrue(myPI.intStack.description == "[ -5 4 5 100 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }
    
    func test_RangeDefine() {
        let myPI = PushInterpreter(script:"foo 1 2 range_fromInts range_define foo foo foo")
        myPI.run()
        XCTAssertTrue(myPI.bindings.count > 0, "Expected \(myPI.bindings) to include foo")
        XCTAssertTrue(myPI.rangeStack.description == "[ (1..2) (1..2) (1..2) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }
    
    func test_RangeDup() {
        let myPI = PushInterpreter(script:"1 range_fromZero 2 range_fromZero range_dup")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (0..1) (0..2) (0..2) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }

    func test_RangeFlip() {
        let myPI = PushInterpreter(script:"1 range_fromZero 2 range_fromZero 3 range_fromZero range_flip")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (0..3) (0..2) (0..1) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }
    
    func test_RangeFromEnds() {
        let myPI = PushInterpreter(script:"-11 14 range_fromInts 3 8 range_fromInts range_fromEnds")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (14..8) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }


    func test_RangeFromInner() {
        let myPI = PushInterpreter(script:"-11 14 range_fromInts 3 8 range_fromInts range_fromInner")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (14..3) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }

    
    func test_RangeFromInts() {
        let myPI = PushInterpreter(script:"-11 11 range_fromInts")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (-11..11) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }
    
    func test_RangeFromOuter() {
        let myPI = PushInterpreter(script:"-11 14 range_fromInts 3 8 range_fromInts range_fromOuter")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (-11..8) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }

    
    func test_RangeFromStarts() {
        let myPI = PushInterpreter(script:"-11 14 range_fromInts 3 8 range_fromInts range_fromStarts")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (-11..3) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }

    
    func test_RangeFromZero() {
        let myPI = PushInterpreter(script:"12 range_fromZero")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (0..12) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }

    
    func test_rangeIsClosed() {
        let myPI = PushInterpreter(script:"-11 11 range_fromInts range_isClosed 3 3 range_fromInts range_isClosed")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ F T ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }

    
    func test_rangeIsUpward() {
        let myPI = PushInterpreter(script:"-11 11 range_fromInts range_isUpward 3 1 range_fromInts range_isUpward 9 9 range_fromInts range_isUpward")
        myPI.run()
        XCTAssertTrue(myPI.boolStack.description == "[ T F F ]", "Didn't expect stack to be \(myPI.boolStack.description)")
    }
    
    func test_rangeMix() {
        let myPI = PushInterpreter(script:"-11 11 range_fromInts 3 1 range_fromInts range_mix")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (-11..1) (3..11) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")

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
    
    func test_RangeScaleDown() {
        let myPI = PushInterpreter(script:"2000 12000 range_fromInts -100 range_scaleDown")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (-20..-120) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }

    func test_RangeScaleUp() {
        let myPI = PushInterpreter(script:"7 11 range_fromInts 22 range_scaleUp")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (154..242) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }

    
    func test_RangeShift() {
        let myPI = PushInterpreter(script:"9912 range_fromZero -1112 range_shift")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (-1112..8800) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }


    func test_RangeShove() {
        let myPI = PushInterpreter(script:"1 2 range_fromInts 3 4 range_fromInts 5 6 range_fromInts 0 range_shove")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (5..6) (1..2) (3..4) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }
    
    func test_RangeSize() {
        let myPI = PushInterpreter(script:"1 2 range_fromInts range_size -313 49812 range_fromInts range_size 5 5 range_fromInts range_size")
        myPI.run()
        XCTAssertTrue(myPI.intStack.description == "[ 1 50125 0 ]", "Didn't expect stack to be \(myPI.intStack.description)")
    }

    
    func test_RangeStep() {
        let myPI = PushInterpreter(script:"1 2 range_fromInts range_step 4 -2 range_fromInts range_step 5 5 range_fromInts range_step")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (2..2) (3..-2) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }

    
    func test_RangeStepBy() {
        let myPI = PushInterpreter(script:"1 10 range_fromInts 3 range_stepBy 4 -21 range_fromInts -5 range_stepBy 5 5 range_fromInts 2 range_stepBy 100 110 range_fromInts 200 range_stepBy")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (4..10) (-1..-21) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }
    
    
    func test_RangeSwap() {
        let myPI = PushInterpreter(script:"1 2 range_fromInts 3 4 range_fromInts 5 6 range_fromInts range_swap")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (1..2) (5..6) (3..4) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }
    
    
    func test_RangeUnstep() {
        let myPI = PushInterpreter(script:"1 2 range_fromInts range_unstep 4 -2 range_fromInts range_unstep 5 5 range_fromInts range_unstep")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (0..2) (5..-2) (4..5) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }

    
    func test_RangeYank() {
        let myPI = PushInterpreter(script:"0 3 range_fromZero 4 range_fromZero 5 range_fromZero range_yank")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (0..4) (0..5) (0..3) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }
    
    
    func test_RangeYankDup() {
        let myPI = PushInterpreter(script:"0 3 range_fromZero 4 range_fromZero 5 range_fromZero range_yankDup")
        myPI.run()
        XCTAssertTrue(myPI.rangeStack.description == "[ (0..3) (0..4) (0..5) (0..3) ]", "Didn't expect stack to be \(myPI.rangeStack.description)")
    }


    
}
