//
//  PushInstructions.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/10/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation



extension PushInterpreter {
    
    
    func loadActiveInstructions() {
        allPushInstructions = [
                    "noop" : {self.noop()},
                 "int_add" : {self.int_add()},
                 "int_div" : {self.int_div()},
                 "int_mod" : {self.int_mod()},
              "int_divmod" : {self.int_divmod()},
            "int_multiply" : {self.int_multiply()},
            "int_subtract" : {self.int_subtract()}
        ]
        
        
        activePushInstructions = []
        for item in allPushInstructions.keys {activePushInstructions += item}
    }

    
    func execute(command:String) {
        if contains(activePushInstructions, command) {
            let do_this = allPushInstructions[command]
            do_this!()
        }
    }

    /////////////////////////////
    // miscellaneous instructions
    
    func noop() {}


    // int functions
    //
    // (done)
    //     INTEGER.%: Pushes the second stack item modulo the top stack item. If the top item is zero this acts as a NOOP. The modulus is computed as the remainder of the quotient, where the quotient has first been truncated toward negative infinity. (This is taken from the definition for the generic MOD function in Common Lisp, which is described for example at http://www.lispworks.com/reference/HyperSpec/Body/f_mod_r.htm.)
    //    INTEGER.*: Pushes the product of the top two items.
    //    INTEGER.+: Pushes the sum of the top two items.
    //    INTEGER.-: Pushes the difference of the top two items; that is, the second item minus the top item.
    //    INTEGER./: Pushes the quotient of the top two items; that is, the second item divided by the top item. If the top item is zero this acts as a NOOP.
    //
    //  (pending)
    //
    //    INTEGER.<: Pushes TRUE onto the BOOLEAN stack if the second item is less than the top item, or FALSE otherwise.
    //    INTEGER.=: Pushes TRUE onto the BOOLEAN stack if the top two items are equal, or FALSE otherwise.
    //    INTEGER.>: Pushes TRUE onto the BOOLEAN stack if the second item is greater than the top item, or FALSE otherwise.
    //    INTEGER.DEFINE: Defines the name on top of the NAME stack as an instruction that will push the top item of the INTEGER stack onto the EXEC stack.
    //    INTEGER.DUP: Duplicates the top item on the INTEGER stack. Does not pop its argument (which, if it did, would negate the effect of the duplication!).
    //    INTEGER.FLUSH: Empties the INTEGER stack.
    //    INTEGER.FROMBOOLEAN: Pushes 1 if the top BOOLEAN is TRUE, or 0 if the top BOOLEAN is FALSE.
    //    INTEGER.FROMFLOAT: Pushes the result of truncating the top FLOAT.
    //    INTEGER.MAX: Pushes the maximum of the top two items.
    //    INTEGER.MIN: Pushes the minimum of the top two items.
    //    INTEGER.POP: Pops the INTEGER stack.
    //    INTEGER.RAND: Pushes a newly generated random INTEGER that is greater than or equal to MIN-RANDOM-INTEGER and less than or equal to MAX-RANDOM-INTEGER.
    //    INTEGER.ROT: Rotates the top three items on the INTEGER stack, pulling the third item out and pushing it on top. This is equivalent to "2 INTEGER.YANK".
    //    INTEGER.SHOVE: Inserts the second INTEGER "deep" in the stack, at the position indexed by the top INTEGER. The index position is calculated after the index is removed.
    //    INTEGER.STACKDEPTH: Pushes the stack depth onto the INTEGER stack (thereby increasing it!).
    //    INTEGER.SWAP: Swaps the top two INTEGERs.
    //    INTEGER.YANK: Removes an indexed item from "deep" in the stack and pushes it on top of the stack. The index is taken from the INTEGER stack, and the indexing is done after the index is removed.
    //    INTEGER.YANKDUP: Pushes a copy of an indexed item "deep" in the stack onto the top of the stack, without removing the deep item. The index is taken from the INTEGER stack, and the indexing is done after the index is removed.
    //
    //  (extra)
    //
    //    int_divmod: Pushes

    
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
    
    
    func int_divmod() {
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
