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

enum PushPoint:Printable {
    
    case Integer(Int)
    case Range(Int,Int)
    case Boolean(Bool)
    case Float(Double)
    case Instruction(String)
    case Name(String)
    case Block(PushPoint[])
    
    
    var value: Any {
    switch self {
    case let Integer(int):
        return int
    case let Range(start,end):
        return (start,end)
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
    
    
    func isRange() -> Bool {
        switch self {
        case .Range(_,_):
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

    func isBlock() -> Bool {
        switch self {
        case .Block(_):
            return true
        default:
            return false
        }
    }
    
    
    func subtree() -> PushPoint[]? {
        switch self {
        case .Block(let array):
            return array
        default:
            return nil
        }
    }
    
    
    var description:String {
        switch self {
        case let Integer(int):
            return "\(int)"
        case let Range(first,last):
            return "(\(first)..\(last))"
        case let Boolean(bool):
            let abbr = bool ? "T" : "F"
            return "\(abbr)"
        case let Float(float):
            return "\(float)"
        case let Instruction(string):
            return ":\(string)"
        case let Name(string):
            return "\"\(string)\""
        case let Block(array):
            return array.reduce("( ") {$0 + "\($1.description) "} + ")"
        }
    }


    
    func clone() -> PushPoint {
        switch self {
        case let Integer(int):
            return PushPoint.Integer(int)
        case let Range(start,end):
            return Range(start,end)
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
