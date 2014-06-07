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


class PushPoint {
}

class LiteralPoint:PushPoint {
}

class IntPoint:LiteralPoint {
    var value:Int? = 0
    init(i:Int?) {
        value = i
    }
}

class BoolPoint:LiteralPoint {
    var value:Bool? = nil
    init(b:Bool?) {
        value = b
    }
}

class FloatPoint:LiteralPoint {
    var value:Double? = nil
    init(d:Double?) {
        value = d
    }
}

class InstructionPoint:LiteralPoint {
    var value:String? = nil
    init(s:String?) {
        value = s
    }
}

class NamePoint:LiteralPoint {
    var value:String? = nil
    init(n:String?) {
        value = n
    }
}

class BlockPoint:PushPoint {
    var contents:PushPoint[] = []
    init(block:PushPoint[]) {
        contents = block
    }
}



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
    var codeStack: PushStack<CodePoint>  = PushStack<CodePoint>()
    var execStack: PushStack<CodePoint>  = PushStack<CodePoint>()

    
    func parse(script:String) -> PushPoint[] {
        
        var tokens:String[] = []
        var points:PushPoint[] = []
        
        tokens = script.componentsSeparatedByCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
            ).filter(
                {(s1:String) -> Bool in return s1 != ""}
        )
        
        
        for token in tokens {
            points.append(programPointFromToken(token))
            
        }
        
        return points
    }
    
    
    func programPointFromToken(token:String) -> PushPoint {
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