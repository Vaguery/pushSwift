// Playground - noun: a place where people can play

import Cocoa


2+2

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
    
    func getBlock() -> PushPoint[] {
        switch self {
            case let Block(array):
                return array
            default:
                return PushPoint[]()
        }
    }
}


let a = PushPoint.Integer(99)
let b = PushPoint.Boolean(false)
let c = PushPoint.Block([a,b])
let d = PushPoint.Block([PushPoint.Name("foo"), PushPoint.Instruction("bar")])
let e = PushPoint.Block([c,d])

e.to_tree()

a.value as Int
b.value as Bool
e.value as Array<PushPoint>

