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

public class PushInterpreter {
    
    public var script:String = ""
    public var program:PushPoint = PushPoint.Block([])
    public var steps = 0
    public var stepLimit = 1000
    public var allPushInstructions:Dictionary<String,Void->Void>
    public var activePushInstructions:[String]

    public var bindings = Dictionary<String,PushPoint>(minimumCapacity: 0)
    
    public var intStack   : PushStack = PushStack()
    public var rangeStack : PushStack = PushStack()
    public var boolStack  : PushStack = PushStack()
    public var floatStack : PushStack = PushStack()
    public var nameStack  : PushStack = PushStack()
    public var codeStack  : PushStack = PushStack()
    public var execStack  : PushStack = PushStack()
    
    
    public init() {
        script = ""
        allPushInstructions = Dictionary<String,Void->Void>(minimumCapacity: 0)
        activePushInstructions = [String]()
        self.loadActiveInstructions()
        self.program = PushPoint.Block([PushPoint]())
        self.reset()
    }
    public init(script:String) {
        self.script = script
        allPushInstructions = Dictionary<String,Void->Void>(minimumCapacity: 0)
        activePushInstructions = [String]()
        self.loadActiveInstructions()
        self.program = PushPoint.Block([PushPoint]())
        self.reset()
    }
    public init(script:String, bindings:Dictionary<String,PushPoint>) {
        self.script = script
        allPushInstructions = Dictionary<String,Void->Void>(minimumCapacity: 0)
        activePushInstructions = [String]()
        self.loadActiveInstructions()
        self.program = PushPoint.Block([PushPoint]())
        self.reset()
        self.bindings = bindings
    }
    
    
    public func parse(script:String) -> [PushPoint] {
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
            pattern: "^([+-])?[0-9]+$", options: nil, error: &error)!
        var probably: Bool
        probably = intRegex.numberOfMatchesInString(s, options: nil,
            range:NSMakeRange(0, (countElements(s)))) == 1 ? true : false
        return probably
    }
    
    
    func thisLooksLikeAdouble(s:String) -> Bool {
        var error : NSError?
        let intRegex = NSRegularExpression(
            pattern: "^[-+]?[0-9]*\\.?[0-9]+([eE][-+]?[0-9]+)?$", options: nil, error: &error)!
        let probably: Bool = intRegex.numberOfMatchesInString(s, options: nil, range: NSMakeRange(0, countElements(s))) == 1 ? true : false
        return probably
    }
    
    
    func stringToDouble(s:String) -> NSNumber {
        return (s as NSString).doubleValue
    }
    
    
    public func pointsFromTokenArray(inout tokens:[String]) -> [PushPoint] {
        var root_block:[PushPoint] = []
        while tokens.count > 0 {
            let this = tokens.removeAtIndex(0)
            switch this {
                case "(":
                    let subtree = grabBlockFromTokenArray(&tokens)
                    root_block.append(PushPoint.Block(subtree))
                case ")":
                    continue // do nothing
                default:
                root_block.append(programPointFromToken(this))
            }
        }
        return root_block
    }
    
    
    func grabBlockFromTokenArray(inout tokens:[String]) -> [PushPoint] {
        var block:[PushPoint] = []
        
        while tokens.count > 0 {
            let this = tokens.removeAtIndex(0)
            switch this {
                case "(":
                    let subtree = grabBlockFromTokenArray(&tokens)
                    block.append(PushPoint.Block(subtree))
                case ")":
                    return block // done here
                default:
                    block.append(programPointFromToken(this))
            }
        }
        return block
    }
    
    
    public func programPointFromToken(token:String) -> PushPoint {
        
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
    
    
    public func bind(name:String, point:PushPoint) {
        self.bindings[name] = point
    }
    
    
    public func clear_stacks() {
        intStack.clear()
        rangeStack.clear()
        boolStack.clear()
        nameStack.clear()
        codeStack.clear()
        floatStack.clear()
        execStack.clear()
    }
    
    
    public func stage(new_script:String) {
        self.script = new_script
        self.program = PushPoint.Block(self.parse(self.script))
    }
    
    
    public func reset() {
        clear_stacks()
        stage(self.script)
        execStack.push(program)
    }

    
    public func resetWithScript(new_script:String) {
        clear_stacks()
        stage(new_script)
        execStack.push(program)
    }
    
    
    public func step() {
        let next_point:PushPoint? = execStack.pop()
        if let point = next_point {
            switch point {
            case .Integer(_):
                intStack.push(point)
            case .Range(_,_):
                rangeStack.push(point)
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
    
    public func run() {
        steps = 0
        while execStack.length() > 0  && steps <= stepLimit {
            steps += 1
            self.step()
        }
    }
}


