//
//  PushInstructions.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/10/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation

extension PushInterpreter {

    
    func execute(command:String) {
        switch command {
        case "int_add":
            self.int_add()
        case "int_div":
            self.int_div()
        case "int_mod":
            self.int_mod()
        case "int_moddiv":
            self.int_moddiv()
        case "int_multiply":
            self.int_multiply()
        case "int_subtract":
            self.int_subtract()

        case "noop":
            self.noop()
        
        default:
            break  // do nothing
        }
    }

    
    func noop() {}

    // int functions
    
    func int_add() {
        if intStack.length() > 1 {
            let v1 = intStack.pop()!.value as Int
            let v2 = intStack.pop()!.value as Int
            let sum = PushPoint.Integer(v1+v2)
            intStack.push(sum)
        }
    }
    
    
    func int_div() {  // protected division
        if intStack.length() > 1 {
            let arg2 = intStack.pop()!.value as Int
            let arg1 = intStack.pop()!.value as Int
            if arg2 != 0 {
                let quotient = PushPoint.Integer(arg1 / arg2)
                intStack.push(quotient)
            } // throw args away otherwise
        }
    }
    
    
    func int_mod() {
        if intStack.length() > 1 {
            let arg2 = intStack.pop()!.value as Int
            let arg1 = intStack.pop()!.value as Int
            if arg2 != 0 {
                let sum = PushPoint.Integer(arg1 % arg2)
                intStack.push(sum)
            } // throw args away otherwise
        }
    }
    
    
    func int_moddiv() {
        if intStack.length() > 1 {
            let arg2 = intStack.pop()!.value as Int
            let arg1 = intStack.pop()!.value as Int
            if arg2 != 0 {
                let quotient = PushPoint.Integer(arg1 / arg2)
                let remainder = PushPoint.Integer(arg1 % arg2)
                intStack.push(quotient)
                intStack.push(remainder)
            } // throw args away otherwise
        }
    }
    
    
    func int_multiply() {
        if intStack.length() > 1 {
            let v1 = intStack.pop()!.value as Int
            let v2 = intStack.pop()!.value as Int
            let product = PushPoint.Integer(v1*v2)
            intStack.push(product)
        }
    }

    
    
    func int_subtract() {
        if intStack.length() > 1 {
            let arg2 = intStack.pop()!.value as Int
            let arg1 = intStack.pop()!.value as Int
            let difference = PushPoint.Integer(arg1 - arg2)
            intStack.push(difference)
        }
    }
}
