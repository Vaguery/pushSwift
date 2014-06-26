//
//  Answers.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/16/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation



func randomIndexFromArray(array:AnyObject[]) -> Int {
    return Int(arc4random_uniform(UInt32(array.count)))
}


func randomDouble() -> Double {
    return Double(drand48())
}


func randomIntegerERC() -> Int {
    return Int(arc4random_uniform(UInt32(100))) - 50
}


func randomBooleanERC() -> Bool {
    let flip = arc4random_uniform(UInt32(2))
    return flip == 0 ? true : false
}

func randomFloatERC() -> Double {
    let numerator = Int(arc4random_uniform(UInt32(12800))) - 6400
    let denominator = 128.0
    return Double(numerator) / denominator
}




class PushAnswer {
    var scores = Dictionary<String,Double>()
    var template = String[]()
    var script : String = ""
    var literals:Dictionary<String,PushPoint>
    var myInstructions:String[] = []
    var myInterpreter:PushInterpreter
    
    
    init(length:Int,
        commands:String[]=[],
        otherTokens:String[]=["(",")","«int»","«bool»","«float»"],
        commandRatio:Double=0.5) {
        
        myInterpreter = PushInterpreter()
        myInstructions = []
            
        if commands.count == 0 {
            myInstructions = myInterpreter.activePushInstructions
        } else {
            myInstructions = commands
        }
            
        literals = Dictionary<String,PushPoint>()
        
        // build script template
        template = []
        for i in 0..length {
            if (randomDouble() < commandRatio) && (myInstructions.count > 0) {
                let idx = randomIndexFromArray(myInstructions)
                template += myInstructions[idx]
            } else if otherTokens.count > 0 {
                let idx = randomIndexFromArray(otherTokens)
                template += otherTokens[idx]
            } else {
                template += "noop"
            }
        }
        
        // build script
        script = ""
        for token in template {
            switch token {
                case "«int»":
                    let val = randomIntegerERC()
                    let name = "int_\(literals.count)"
                    literals[name] = PushPoint.Integer(val)
                    script += "\(name) "
                case "«bool»":
                    let val = randomBooleanERC()
                    let name = "bool_\(literals.count)"
                    literals[name] = PushPoint.Boolean(val)
                    script += "\(name) "
                case "«float»":
                    let val = randomFloatERC()
                    let name = "float_\(literals.count)"
                    literals[name] = PushPoint.Float(val)
                    script += "\(name) "
                default:
                    script += "\(token) "
            }
        }
        
    }
}
