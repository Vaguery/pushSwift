//
//  PushPoint.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/10/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation

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
    
    
    func isFloat() -> Bool {
        switch self {
        case .Float(_):
            return true
        default:
            return false
        }
    }
    
    
    func isName() -> Bool {
        switch self {
        case .Name(_):
            return true
        default:
            return false
        }
    }
    
    
    func isInstruction() -> Bool {
        switch self {
        case .Instruction(_):
            return true
        default:
            return false
        }
    }

    
    
    func clone() -> PushPoint {
        switch self {
        case let Integer(int):
            return PushPoint.Integer(int)
        case let Boolean(bool):
            return PushPoint.Boolean(bool)
        case let Float(float):
            return PushPoint.Float(float)
        case let Instruction(string):
            return PushPoint.Instruction(string)
        case let Name(string):
            return PushPoint.Name(string)
        case let Block(array):
            let new_points = array.map({i in i.clone()})
            return PushPoint.Block(new_points)
        }
    }
}
