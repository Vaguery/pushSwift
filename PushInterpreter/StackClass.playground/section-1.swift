// Playground - noun: a place where people can play

import Cocoa
import XCTest

// PushProgramPoints

2+2

// DeepCopyable

@objc protocol DeepCopyable {
    class func deep_copy() -> Self
}


class NonconformingClass {
}


class ImmediatelyConformingClass: DeepCopyable {
    class func deep_copy() -> ImmediatelyConformingClass { return ImmediatelyConformingClass() }
}


class EventuallyConformingClass {
}


//struct ConformingStruct:DeepCopyable {
//    mutating func deep_copy() -> ConformingStruct { return ConformingStruct() }
//}


extension EventuallyConformingClass: DeepCopyable {
    class func deep_copy() -> EventuallyConformingClass { return EventuallyConformingClass() }
}


NonconformingClass() as? DeepCopyable
ImmediatelyConformingClass() as? DeepCopyable
EventuallyConformingClass() as? DeepCopyable


// Parsing scripts

class PushParser {
    
    var tokens:String[] = []
    
    func parseScript(script:String) {
        self.tokens = script.componentsSeparatedByString(" ")
    }
}

var myParser = PushParser()
myParser.parseScript("foo bar")
myParser.tokens

