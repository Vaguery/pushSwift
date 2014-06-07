// Playground - noun: a place where people can play

import Cocoa
import XCTest

// PushProgramPoints

2+2

// DeepCopyable

@objc protocol DeepCopyable {
    func deep_copy() -> Self
}


class NonconformingClass {
}


class ImmediatelyConformingClass: DeepCopyable {
    func deep_copy() -> ImmediatelyConformingClass { return ImmediatelyConformingClass() }
}


class EventuallyConformingClass {
}

//struct ConformingStruct:DeepCopyable {
//    func deep_copy() -> ConformingStruct { return ConformingStruct() }
//}


extension EventuallyConformingClass: DeepCopyable {
    func deep_copy() -> EventuallyConformingClass { return EventuallyConformingClass() }
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

// Tring to understand subclassed generics

class GenericThing<T> {
    var myValue = 88
}

class SomewhatLessGenericThing<T>:GenericThing<T> {
    var myOtherValue = 999
}

let myThing = SomewhatLessGenericThing<Int>()
myThing.myOtherValue = 2

// Versus standard subclasses

class CoreClassThing {
    var myValue = 11
}

class SubclassedThing:CoreClassThing,DeepCopyable {
    var myOtherValue = 22
    func deep_copy() -> SubclassedThing {
        return SubclassedThing()
    }
}

let x = SubclassedThing()
let y = SubclassedThing().deep_copy()


// exploring string matching


