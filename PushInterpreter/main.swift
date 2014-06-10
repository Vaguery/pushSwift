//
//  main.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/4/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Cocoa

NSApplicationMain(C_ARGC, C_ARGV)

/////////////////////////////////////////
// Code points in parsed Push language...

enum PushPoint {
    
    case Integer(Int)
    case Boolean(Bool)
    case Float(Double)
    case Instruction(String)
    case Name(String)
    case Block(PushPoint[])
    
    var value: Any {
    switch self {
        case let Integer(int):
            return int
        case let Boolean(bool):
            return bool
        case let Float(float):
            return float
        case let Instruction(string):
            return string
        case let Name(string):
            return string
        case let Block(array):
            return array
        }
    }
    
    func subtree() -> PushPoint[] {
        switch self {
        case .Block(let array):
            return array
        default:
            return PushPoint[]()
        }
    }
    
    func isInteger() -> Bool {
        switch self {
        case .Integer(_):
            return true
        default:
            return false
        }
    }
    
    func isBoolean() -> Bool {
        switch self {
        case .Boolean(_):
            return true
        default:
            return false
        }
    }

    
    
}


//////////////
// Push Stacks

class PushStack {
    
    var items:PushPoint[] = []
    
    func push(item: PushPoint) {
        items.append(item)
    }
    
    func pop() -> PushPoint? {
        if items.count == 0 {
            return nil
        } else {
            return items.removeLast()
        }
    }
    
    func length() -> Int {
        return items.count
    }
    
    func swap() {
        if items.count > 1 {
            let old_top = self.pop()
            let old_second = self.pop()
            self.push(old_top!)
            self.push(old_second!)
        }
    }
    
    func dup() {
        items.unshare()
        if items.count > 0 {
            let top_one = self.pop()
            let new_one = top_one!
            self.push(top_one!)
            self.push(new_one)
            // this will cause trouble for complex items
        }
    }
}

//////////////////
// PushInterpreter

class PushInterpreter {
    
    var intStack   : PushStack = PushStack()
    var boolStack  : PushStack = PushStack()
    var floatStack : PushStack = PushStack()
    var nameStack  : PushStack = PushStack()
    var codeStack  : PushStack = PushStack()
    var execStack  : PushStack = PushStack()

    
    func parse(script:String) -> PushPoint[] {
        var tokens = String[]()
        
        tokens = script.componentsSeparatedByCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
            ).filter(
                {(s1:String) -> Bool in return s1 != ""}
        )
        
        return tokens.map( {self.programPointFromToken($0) } )
        
    }
    
    
    func programPointFromToken(token:String) -> PushPoint {
        switch token {
            case "T":
                return PushPoint.Boolean(true)
            case "F":
                return PushPoint.Boolean(false)
            default:
                return PushPoint.Name(token)
        }
    }
}