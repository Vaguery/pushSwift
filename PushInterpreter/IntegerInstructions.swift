//
//  IntegerInstructions.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/13/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation

extension PushInterpreter {
    
    func loadIntegerInstructions() {
        let intInstructions = [
                    "int_add" : {self.int_add()},
                "int_archive" : {self.int_archive()},
                 "int_define" : {self.int_define()},
                  "int_depth" : {self.int_depth()},
                    "int_div" : {self.int_div()},
                 "int_divmod" : {self.int_divmod()},
                    "int_dup" : {self.int_dup()},
                  "int_equal" : {self.int_equal()},
                   "int_flip" : {self.int_flip()},
                  "int_flush" : {self.int_flush()},
               "int_fromBool" : {self.int_fromBool()},
              "int_fromFloat" : {self.int_fromFloat()},
            "int_greaterThan" : {self.int_greaterThan()},
             "int_isPositive" : {self.int_isPositive()},
               "int_lessThan" : {self.int_lessThan()},
                    "int_max" : {self.int_max()},
                    "int_min" : {self.int_min()},
                    "int_mod" : {self.int_mod()},
               "int_multiply" : {self.int_multiply()},
                    "int_pop" : {self.int_pop()},
                 "int_rotate" : {self.int_rotate()},
               "int_subtract" : {self.int_subtract()},
                   "int_swap" : {self.int_swap()},
                   "int_yank" : {self.int_yank()},
                "int_yankDup" : {self.int_yankDup()}
        ]
        
        for (k,v) in intInstructions {
            allPushInstructions[k] = v
        }

    }
    
    ////////////////
    // int functions
    //
    //  (comments are quotes from http://faculty.hampshire.edu/lspector/push3-description.html where available)
    
    
    
    //  INTEGER.+: Pushes the sum of the top two items.
    
    func int_add() {
        if intStack.length() > 1 {
            let v1 = intStack.pop()!.value as Int
            let v2 = intStack.pop()!.value as Int
            let sum = PushPoint.Integer(v1+v2)
            intStack.push(sum)
        }
    }
    
    
    //  int_archive()
    func int_archive() {
        if intStack.length() > 0 {
            let arg = intStack.pop()!
            execStack.items.insert(arg, atIndex: 0)
        }
    }

    
    //  INTEGER.DEFINE: Defines the name on top of the NAME stack as an instruction that will push the top item of the INTEGER stack onto the EXEC stack.
    func int_define() {
        if intStack.length() > 0 && nameStack.length() > 0 {
            let point = intStack.pop()!
            let name = nameStack.pop()!.value as String
            self.bind(name, point: point)
        }
    }
    
    
    //  INTEGER.STACKDEPTH: Pushes the stack depth onto the INTEGER stack (thereby increasing it!).
    func int_depth() {
        let d = intStack.length()
        intStack.push(PushPoint.Integer(d))
    }
    
    
    //  INTEGER./: Pushes the quotient of the top two items; that is, the second item divided by the top item. If the top item is zero this acts as a NOOP.
    
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
    
    
    //  (not part of Push 3.0 spec)
    
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
    
    
    //  INTEGER.DUP: Duplicates the top item on the INTEGER stack. Does not pop its argument (which, if it did, would negate the effect of the duplication!).
    func int_dup() {
        intStack.dup()
    }
    
    
    //  INTEGER.=: Pushes TRUE onto the BOOLEAN stack if the top two items are equal, or FALSE otherwise.
    
    func int_equal() {
        if intStack.length() > 1 {
            let arg2 = intStack.pop()!.value as Int
            let arg1 = intStack.pop()!.value as Int
            boolStack.push(PushPoint.Boolean(arg1 == arg2))
        }
    }
    
    
    //  int_flip()
    func int_flip() {
        intStack.flip()
    }
    
    
    //  INTEGER.FLUSH: Empties the INTEGER stack.
    func int_flush() {
        intStack.clear()
    }
    
    //  INTEGER.FROMBOOLEAN: Pushes 1 if the top BOOLEAN is TRUE, or 0 if the top BOOLEAN is FALSE.
    func int_fromBool() {
        if boolStack.length() > 0 {
            let bit = boolStack.pop()!.value as Bool
            let out = bit ? 1 : 0
            intStack.push(PushPoint.Integer(out))
        }
    }
    
    
    //  INTEGER.FROMFLOAT: Pushes the result of truncating the top FLOAT.
    func int_fromFloat() {
        if floatStack.length() > 0 {
            let val = floatStack.pop()!.value as Double
            intStack.push(PushPoint.Integer(Int(trunc(val))))
        }
    }

    
    //  INTEGER.>: Pushes TRUE onto the BOOLEAN stack if the second item is greater than the top item, or FALSE otherwise.
    
    func int_greaterThan() {
        if intStack.length() > 1 {
            let arg2 = intStack.pop()!.value as Int
            let arg1 = intStack.pop()!.value as Int
            boolStack.push(PushPoint.Boolean(arg1 > arg2))
        }
    }
    
    
    // int_isPositive(): replaces Push 3.0 BOOLEAN.FROMINT
    func int_isPositive() {
        if intStack.length() > 0 {
            let arg = intStack.pop()!.value as Int
            let q:Bool = (arg >= 0)
            boolStack.push(PushPoint.Boolean(q))
        }
    }

    
    
    //  INTEGER.<: Pushes TRUE onto the BOOLEAN stack if the second item is less than the top item, or FALSE otherwise.
    func int_lessThan() {
        if intStack.length() > 1 {
            let arg2 = intStack.pop()!.value as Int
            let arg1 = intStack.pop()!.value as Int
            boolStack.push(PushPoint.Boolean(arg1 < arg2))
        }
    }
    
    
    //  INTEGER.MAX: Pushes the maximum of the top two items.
    
    func int_max() {
        if intStack.length() > 1 {
            let arg2 = intStack.pop()!.value as Int
            let arg1 = intStack.pop()!.value as Int
            intStack.push(PushPoint.Integer(max(arg1,arg2)))
        }
    }
    
    
    //  INTEGER.MIN: Pushes the minimum of the top two items.
    
    func int_min() {
        if intStack.length() > 1 {
            let arg2 = intStack.pop()!.value as Int
            let arg1 = intStack.pop()!.value as Int
            intStack.push(PushPoint.Integer(min(arg1,arg2)))
        }
    }
    
    
    //  INTEGER.%: Pushes the second stack item modulo the top stack item. If the top item is zero this acts as a NOOP....
    
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
    
    
    //  INTEGER.*: Pushes the product of the top two items.
    
    func int_multiply() {
        if intStack.length() > 1 {
            let v1 = intStack.pop()!.value as Int
            let v2 = intStack.pop()!.value as Int
            let product = PushPoint.Integer(v1*v2)
            intStack.push(product)
        }
    }
    
    
    //  INTEGER.POP: Pops the INTEGER stack.
    func int_pop() {
        let discard = intStack.pop()
    }
    
    
    //  INTEGER.ROT: Rotates the top three items on the INTEGER stack, pulling the third item out and pushing it on top. This is equivalent to "2 INTEGER.YANK".
    func int_rotate() {
        intStack.rotate()
    }

    
    
    //  INTEGER.-: Pushes the difference of the top two items; that is, the second item minus the top item.
    
    func int_subtract() {
        if intStack.length() > 1 {
            let arg2 = intStack.pop()!.value as Int
            let arg1 = intStack.pop()!.value as Int
            let difference = PushPoint.Integer(arg1 - arg2)
            intStack.push(difference)
        }
    }
    
    
    //  INTEGER.SWAP: Swaps the top two INTEGERs.
    func int_swap() {
        intStack.swap()
    }
    
    
    //  INTEGER.YANK: Removes an indexed item from "deep" in the stack and pushes it on top of the stack. The index is taken from the INTEGER stack, and the indexing is done after the index is removed.
    func int_yank() {
        if intStack.length() > 0 {
            let d = intStack.pop()!.value as Int
            intStack.yank(d)
        }
    }

    //    INTEGER.YANKDUP: Pushes a copy of an indexed item "deep" in the stack onto the top of the stack, without removing the deep item. The index is taken from the INTEGER stack, and the indexing is done after the index is removed.
    func int_yankDup() {
        if intStack.length() > 0 {
            let d = intStack.pop()!.value as Int
            intStack.yankDup(d)
        }
    }

}