//
//  main.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/4/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Cocoa

NSApplicationMain(C_ARGC, C_ARGV)

//////////////////////////////
// PushCodePoints (simplified)

enum PushType {
    case Noop
    case Integer(Int)
    case Boolean(Bool)
    case Float(Double)
    case Instruction(String)
    case Name(String)
    case Block(PushPoint[])
}


class PushPoint {
    
    var value:PushType
    
    init(){self.value = PushType.Noop}
    init(bool:Bool){self.value = PushType.Boolean(bool)}
    init(int:Int){self.value=PushType.Integer(int)}
    init(float:Double){self.value=PushType.Float(float)}
    init(instruction:String){self.value=PushType.Instruction(instruction)}
    init(name:String){self.value=PushType.Instruction(name)}
    init(block:PushPoint[]){self.value=PushType.Block(block)}
    
    func raw() -> Any {
        switch self.value {
        case .Integer(let number):
            return Int(number)
        case .Float(let number):
            return Double(number)
        case .Boolean(let truth):
            return Bool(truth)
        case .Instruction(let token):
            return String(token)
        case .Name(let name):
            return String(name)
        case .Block(let subtree):
            return "block"
        default:
            return "nope"
        }
    }
    
    func to_tree() -> String {
        var tree = ""
        switch self.value {
        case .Integer(let number):
            tree += " \(number)"
        case .Float(let number):
            tree += " \(number)"
        case .Boolean(let truth):
            tree += " \(truth)"
        case .Instruction(let token):
            tree += " \(token)"
        case .Name(let name):
            tree += " \(name)"
        case .Block(let subtree):
            tree += " ("
            for node in subtree {
                tree += node.to_tree()
            }
            tree += " )"
        default:
            tree += " something"
        }
        return tree
    }
}




/////////
// Stacks

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
        var parsedPoints = PushPoint[]()
        
        tokens = script.componentsSeparatedByCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
            ).filter(
                {(s1:String) -> Bool in return s1 != ""}
        )
        
        for token in tokens {
            parsedPoints.append(programPointFromToken(token))
        }
        
        return parsedPoints
    }
    
    
    func programPointFromToken(token:String) -> PushPoint {
        switch token {
            case "T":
                return PushPoint(bool: true)
            case "F":
                return PushPoint(bool:false)
            default:
                return PushPoint(name: token)
        }
    }
}