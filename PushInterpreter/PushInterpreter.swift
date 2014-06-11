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
    
    var listOfPushInstructions = ["noop"]
    
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
    
    
    func thisLooksLikeAnInstruction(s:String) -> Bool {
        return contains(listOfPushInstructions,s)
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
        default:
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
        
    }
}


