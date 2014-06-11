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
    
    let allPushInstructions = ["noop"]
    var activePushInstructions = ["noop"]
    
    var script:String
    var program = PushPoint.Block([])
    var steps = 0
    
    var intStack   : PushStack = PushStack()
    var boolStack  : PushStack = PushStack()
    var floatStack : PushStack = PushStack()
    var nameStack  : PushStack = PushStack()
    var codeStack  : PushStack = PushStack()
    var execStack  : PushStack = PushStack()
    
    
    init() { self.script = "" }
    init(script:String) { self.script = script }
    
    
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
    
    
    func setup(script:String) {
        program = PushPoint.Block(parse(script))
    }
}


