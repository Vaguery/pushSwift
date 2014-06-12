//
//  PushInstructions.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/10/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation

extension PushInterpreter {
    
    func noop() {}

    func int_add() {
        if intStack.length() > 1 {
            let v1 = intStack.pop()!.value as Int
            let v2 = intStack.pop()!.value as Int
            let sum = PushPoint.Integer(v1+v2)
            intStack.push(sum)
        }
    }
}
