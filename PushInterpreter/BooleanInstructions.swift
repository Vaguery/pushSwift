//
//  BooleanInstructions.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/13/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation

extension PushInterpreter {
    func loadBooleanInstructions() {
        
        let boolInstructions = [
            "bool_and" : {self.bool_and()},
            "bool_dup" : {self.bool_dup()},
          "bool_equal" : {self.bool_equal()},
          "bool_flush" : {self.bool_flush()},
            "bool_not" : {self.bool_not()},
             "bool_or" : {self.bool_or()},
            "bool_pop" : {self.bool_pop()},
         "bool_rotate" : {self.bool_rotate()}
        ]
        
        for (k,v) in boolInstructions {
            allPushInstructions[k] = v
        }
        
    }
    
    ///////////////////////
    // boolean instructions
    
    //  (pending)
    //  (comments are quotes from http://faculty.hampshire.edu/lspector/push3-description.html where available)

    
    //  BOOLEAN.DEFINE: Defines the name on top of the NAME stack as an instruction that will push the top item of the BOOLEAN stack onto the EXEC stack.
    //  BOOLEAN.FROMFLOAT: Pushes FALSE if the top FLOAT is 0.0, or TRUE otherwise.
    //  BOOLEAN.FROMINTEGER: Pushes FALSE if the top INTEGER is 0, or TRUE otherwise.
    //  BOOLEAN.RAND: Pushes a random BOOLEAN.
    //  BOOLEAN.SHOVE: Inserts the top BOOLEAN "deep" in the stack, at the position indexed by the top INTEGER.
    //  BOOLEAN.STACKDEPTH: Pushes the stack depth onto the INTEGER stack.
    //  BOOLEAN.SWAP: Swaps the top two BOOLEANs.
    //  BOOLEAN.YANK: Removes an indexed item from "deep" in the stack and pushes it on top of the stack. The index is taken from the INTEGER stack.
    //  BOOLEAN.YANKDUP: Pushes a copy of an indexed item "deep" in the stack onto the top of the stack, without removing the deep item. The index is taken from the INTEGER stack.

    
    //  BOOLEAN.AND: Pushes the logical AND of the top two BOOLEANs.
    func bool_and() {
        if boolStack.length() > 1 {
            let arg1 = boolStack.pop()!.value as Bool
            let arg2 = boolStack.pop()!.value as Bool
            boolStack.push(PushPoint.Boolean(arg1 && arg2))
        }
    }
    
    
    //  BOOLEAN.DUP: Duplicates the top item on the BOOLEAN stack. Does not pop its argument (which, if it did, would negate the effect of the duplication!).
    func bool_dup() {
        boolStack.dup()
    }
    
    
    //  BOOLEAN.=: Pushes TRUE if the top two BOOLEANs are equal, or FALSE otherwise.
    func bool_equal() {
        if boolStack.length() > 1 {
            let arg1 = boolStack.pop()!.value as Bool
            let arg2 = boolStack.pop()!.value as Bool
            boolStack.push(PushPoint.Boolean(arg1 == arg2))
        }
    }
    
    
    //  BOOLEAN.FLUSH: Empties the BOOLEAN stack.
    func bool_flush() {
        boolStack.clear()
    }

    
    //  BOOLEAN.NOT: Pushes the logical NOT of the top BOOLEAN.
    func bool_not() {
        if boolStack.length() > 0 {
            let arg = boolStack.pop()!.value as Bool
            boolStack.push(PushPoint.Boolean(!arg))
        }
    }

    
    //  BOOLEAN.OR: Pushes the logical OR of the top two BOOLEANs.
    func bool_or() {
        if boolStack.length() > 1 {
            let arg1 = boolStack.pop()!.value as Bool
            let arg2 = boolStack.pop()!.value as Bool
            boolStack.push(PushPoint.Boolean(arg1 || arg2))
        }
    }
    
    //  BOOLEAN.POP: Pops the BOOLEAN stack.
    func bool_pop() {
        let discard = boolStack.pop()
    }
    
    //  BOOLEAN.ROT: Rotates the top three items on the BOOLEAN stack, pulling the third item out and pushing it on top. This is equivalent to "2 BOOLEAN.YANK".
    func bool_rotate() {
        boolStack.rotate()
    }

}