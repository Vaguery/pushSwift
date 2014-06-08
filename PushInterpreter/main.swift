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


protocol DeepCopyable {
    func deep_copy() -> Self
}


class PushPoint {  // Abstract
}


class LiteralPoint:PushPoint {
}


class IntPoint:LiteralPoint {
    var value:Int = 0
    init(i:Int) {
        value = i
    }
    func deep_copy() -> IntPoint {
        return IntPoint(i: value)
    }
}
extension IntPoint: DeepCopyable {}


class BoolPoint:LiteralPoint {
    var value:Bool = false
    init(b:Bool) {
        value = b
    }
    func deep_copy() -> BoolPoint {
        return BoolPoint(b: value)
    }
}
extension BoolPoint: DeepCopyable {}



class FloatPoint:LiteralPoint {
    var value:Double = 0.0
    init(d:Double) {
        value = d
    }
    func deep_copy() -> FloatPoint {
        return FloatPoint(d: value)
    }
}
extension FloatPoint: DeepCopyable {}



class InstructionPoint:LiteralPoint {
    var value:String = ""
    init(s:String) {
        value = s
    }
    func deep_copy() -> InstructionPoint {
        return InstructionPoint(s: value)
    }
}
extension InstructionPoint: DeepCopyable {}


class NamePoint:LiteralPoint {
    var value:String = ""
    init(n:String) {
        value = n
    }
    func deep_copy() -> NamePoint {
        return NamePoint(n: value)
    }
}
extension NamePoint: DeepCopyable {}




class BlockPoint:PushPoint {
    var value:DeepCopyable[] = []
    
    init(points: DeepCopyable[]) {
        for item in points {
            value += item.deep_copy()
        }
    }
    
    func deep_copy() -> BlockPoint {
        var copy:DeepCopyable[] = []
        if value.count > 0 {
            copy = value.map( {item in item.deep_copy()} )
        }
        return BlockPoint(points: copy)
    }
}
extension BlockPoint: DeepCopyable {}




/////////
// Stacks

class PushStack<T> {
    
    var items = T[]()
    
    func push(item: T) {
        items.append(item)
    }
    
    func pop() -> T? {
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
    
    var intStack:  PushStack<IntPoint>   = PushStack<IntPoint>()
    var boolStack: PushStack<BoolPoint>  = PushStack<BoolPoint>()
    var floatStack:PushStack<FloatPoint> = PushStack<FloatPoint>()
    var codeStack: PushStack<PushPoint>  = PushStack<PushPoint>()
    var execStack: PushStack<PushPoint>  = PushStack<PushPoint>()

    
    func parse(script:String) -> BlockPoint {
        
        var tokens:String[] = []
        var points = BlockPoint(points:[])
        
        tokens = script.componentsSeparatedByCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
            ).filter(
                {(s1:String) -> Bool in return s1 != ""}
        )
        
        for token in tokens {
            points.value.append(programPointFromToken(token))
        }
        
        return points
    }
    
    
    func programPointFromToken(token:String) -> DeepCopyable {
        switch token {
            case "T":
                return BoolPoint(b: true)
            case "F":
                return BoolPoint(b:false)
            default:
                return NamePoint(n: token)
        }
    }
}