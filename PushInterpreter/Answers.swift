//
//  Answers.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/16/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation


public func randomIndexFromArray(array:[AnyObject]) -> Int {
    return Int(arc4random_uniform(UInt32(array.count)))
}


public func randomDouble() -> Double {
    return Double(drand48())
}


public func randomIntegerERC() -> Int {
    return Int(arc4random_uniform(UInt32(100))) - 50
}


public func randomBooleanERC() -> Bool {
    let flip = arc4random_uniform(UInt32(2))
    return flip == 0 ? true : false
}

public func randomFloatERC() -> Double {
    let numerator = Int(arc4random_uniform(UInt32(12800))) - 6400
    let denominator = 128.0
    return Double(numerator) / denominator
}




public class PushAnswer {
    public var scores = [String:Double]()
    public var template = [String]()
    public var script : String = ""
    public var literals:[String:PushPoint]
    public var myInstructions:[String] = []
    public let uniqueID = NSUUID()
    public var interpreter:PushInterpreter
    
    
    public init(length:Int,
        commands:[String]=[],
        otherTokens:[String]=["(",")","«int»","«bool»","«float»"],
        commandRatio:Double=0.5) {
        
        interpreter = PushInterpreter()
        myInstructions = []
            
        if commands.count == 0 {
            myInstructions = interpreter.activePushInstructions
        } else {
            myInstructions = commands
        }
            
        literals = [String:PushPoint]()
        
        
        // build script template
        template = []
        for i in 0..<length {
            if (randomDouble() < commandRatio) && (myInstructions.count > 0) {
                let idx = randomIndexFromArray(myInstructions)
                template.append(myInstructions[idx])
            } else if otherTokens.count > 0 {
                let idx = randomIndexFromArray(otherTokens)
                template.append(otherTokens[idx])
            } else {
                template.append("noop")
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
        
        interpreter.resetWithScript(script)
        self.reset()
    }
    
    
    public func reset() {
        interpreter.reset()
        interpreter.bindings.removeAll(keepCapacity: true)
        for (erc,push_value) in literals {
            interpreter.bindings[erc] = push_value
        }
    }
    
    public func resetWithBindings(new_bindings:[String:String]) {
        interpreter.reset()
        interpreter.bindings.removeAll(keepCapacity: true)
        for (erc,push_value) in literals {
            interpreter.bindings[erc] = push_value
        }
        for (variable_name,unparsed_pt) in new_bindings {
            interpreter.bindings[variable_name] =
                PushPoint.Block(interpreter.parse(unparsed_pt))
        }
    }
    
    public func run() {
        interpreter.run()
    }
}
