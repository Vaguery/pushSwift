// Playground - noun: a place where people can play

import Cocoa


2+2

enum PushPoint {
    
    case Noop
    case Integer(Int)
    case Boolean(Bool)
    case Float(Double)
    case Instruction(String)
    case Name(String)
    case Block(PushPoint[])
    
    var value: Any? {
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
    case Noop:
        return nil
        }
    }
    
    func to_tree() -> String {
        var tree = ""
        switch self {
        case .Integer(let number):
            tree += " \(number)"
        case .Float(let number):
            tree += " \(number)"
        case .Boolean(let truth):
            tree += " \(truth)"
        case .Instruction(let token):
            tree += " \(token)"
        case .Name(let name):
            tree += " \(name)"
        case .Block(let subtree):
            tree += " ("
            for node in subtree {
                tree += node.to_tree()
            }
            tree += " )"
        default:
            tree += " something"
        }
        return tree
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
