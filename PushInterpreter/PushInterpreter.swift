//
//  PushInterpreter.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/10/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation

//////////////////
// PushInterpreter

class PushInterpreter {
    
    var script:String
    var program:PushPoint
    var steps = 0
    var activePushInstructions:String[] = ["noop", "int_add", "int_div", "int_mod", "int_moddiv", "int_multiply", "int_subtract"]

    var bindings = Dictionary<String,PushPoint>()
    
    var intStack   : PushStack = PushStack()
    var boolStack  : PushStack = PushStack()
    var floatStack : PushStack = PushStack()
    var nameStack  : PushStack = PushStack()
    var codeStack  : PushStack = PushStack()
    var execStack  : PushStack = PushStack()
    
    
    init() {
        self.script = ""
        self.program = PushPoint.Block(PushPoint[]())
    }
    init(script:String) {
        self.script = script
        self.program = PushPoint.Block(PushPoint[]())
        self.program = PushPoint.Block(self.parse(script))
    }
    
    
    func parse(script:String) -> PushPoint[] {
        var tokens = script.componentsSeparatedByCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()).filter(
                    {(s1:String) -> Bool in return s1 != ""}
                )
        return pointsFromTokenArray(&tokens)
    }
    
    
    func thisLooksLikeAnInstruction(s:String) -> Bool {
        return contains(activePushInstructions,s)
    }
    
    
    func thisLooksLikeAnInteger(s:String) -> Bool {
        var error : NSError?
        let intRegex = NSRegularExpression(
            pattern: "^([+-])?[0-9]+$", options: nil, error: &error)
        let probably: Bool = intRegex.numberOfMatchesInString(s, options: nil, range: NSMakeRange(0, countElements(s))) == 1 ? true : false
        return probably
    }
    
    
    func thisLooksLikeAdouble(s:String) -> Bool {
        var error : NSError?
        let intRegex = NSRegularExpression(
            pattern: "^[-+]?[0-9]*\\.?[0-9]+([eE][-+]?[0-9]+)?$", options: nil, error: &error)
        let probably: Bool = intRegex.numberOfMatchesInString(s, options: nil, range: NSMakeRange(0, countElements(s))) == 1 ? true : false
        return probably
    }
    
    
    func stringToDouble(s:String) -> NSNumber {
        return s.bridgeToObjectiveC().floatValue
    }
    
    
    func pointsFromTokenArray(inout tokens:String[]) -> PushPoint[] {
        var root_block:PushPoint[] = []
        while tokens.count > 0 {
            let this = tokens.removeAtIndex(0)
            switch this {
                case "(":
                    let subtree = grabBlockFromTokenArray(&tokens)
                    root_block += PushPoint.Block(subtree)
                case ")":
                    continue // do nothing
                default:
                root_block += programPointFromToken(this)
            }
        }
        return root_block
    }
    
    
    func grabBlockFromTokenArray(inout tokens:String[]) -> PushPoint[] {
        var block:PushPoint[] = []
        
        while tokens.count > 0 {
            let this = tokens.removeAtIndex(0)
            switch this {
                case "(":
                    let subtree = grabBlockFromTokenArray(&tokens)
                    block += PushPoint.Block(subtree)
                case ")":
                    return block // done here
                default:
                    block += programPointFromToken(this)
            }
        }
        return block
    }
    
    
    func programPointFromToken(token:String) -> PushPoint {
        
        // the easy ones first
        
        if thisLooksLikeAnInstruction(token) {
            return PushPoint.Instruction(token)
        }
        
        switch token {
        case "T":
            return PushPoint.Boolean(true)
        case "F":
            return PushPoint.Boolean(false)
        default:    // and that leaves the regular expression ones
            if thisLooksLikeAnInteger(token) {
                return PushPoint.Integer(token.toInt()!)
            } else if thisLooksLikeAdouble(token) {
                return PushPoint.Float(Double(stringToDouble(token)))
            } else {
                return PushPoint.Name(token)
            }
        }
    }
    
    
    func bind(name:String, point:PushPoint) {
        self.bindings[name] = point
    }
    
    
    func clear_stacks() {
        intStack.clear()
        boolStack.clear()
        nameStack.clear()
        codeStack.clear()
        floatStack.clear()
        execStack.clear()
    }
    
    func stage(new_script:String) {
        self.script = new_script
        self.program = PushPoint.Block(self.parse(self.script))
    }
    
    
    func reset() {
        clear_stacks()
        stage(self.script)
        execStack.push(program)
    }

    
    func resetWithScript(new_script:String) {
        clear_stacks()
        stage(new_script)
        execStack.push(program)
    }
    
    
    func step() {
        let next_point:PushPoint? = execStack.pop()
        if let point = next_point {
            switch point {
            case .Integer(_):
                intStack.push(point)
            case .Float(_):
                floatStack.push(point)
            case .Boolean(_):
                boolStack.push(point)
            case .Name(let name):
                if let val = self.bindings[name] {
                    execStack.push(val.clone())
                } else {
                    nameStack.push(point)
                }
            case .Block(let subtree):
                for item in subtree.reverse() {execStack.push(item)}
            case .Instruction(let command):
                if (activePushInstructions.filter {$0 == command}).count > 0 {
                    self.execute(command)
                } else {
                    nameStack.push(PushPoint.Name(command))
                }
            }
        }
    }
    
    func run() {
        self.reset()
        while execStack.length() > 0 {
            self.step()
        }
    }
}


