//
//  NameInstructions.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/13/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation


extension PushInterpreter {
    func loadNameInstructions() {
        
        let nameInstructions = [
                 "name_depth" : {self.name_depth()},
                   "name_dup" : {self.name_dup()},
                  "name_flip" : {self.name_flip()},
                 "name_flush" : {self.name_flush()},
               "name_isEqual" : {self.name_isEqual()},
            "name_isAssigned" : {self.name_isAssigned()},
                   "name_new" : {self.name_new()},
                   "name_pop" : {self.name_pop()},
                 "name_rotate": {self.name_rotate()},
                 "name_shove" : {self.name_shove()},
                  "name_swap" : {self.name_swap()}
        ]
        
        for (k,v) in nameInstructions {
            allPushInstructions[k] = v
        }
        
    }
    
    
    ////////////////////
    // code instructions
    // via http://faculty.hampshire.edu/lspector/push3-description.html
    //
    // (pending)

//        NAME.QUOTE: Sets a flag indicating that the next name encountered will be pushed onto the NAME stack (and not have its associated value pushed onto the EXEC stack), regardless of whether or not it has a definition. Upon encountering such a name and pushing it onto the NAME stack the flag will be cleared (whether or not the pushed name had a definition).
//        NAME.RANDBOUNDNAME: Pushes a randomly selected NAME that already has a definition.
//        NAME.YANK: Removes an indexed item from "deep" in the stack and pushes it on top of the stack. The index is taken from the INTEGER stack.
//        NAME.YANKDUP: Pushes a copy of an indexed item "deep" in the stack onto the top of the stack, without removing the deep item. The index is taken from the INTEGER stack.

    
    //  NAME.STACKDEPTH: Pushes the stack depth onto the INTEGER stack.
    func name_depth() {
        let d = nameStack.length()
        intStack.push(PushPoint.Integer(d))
    }
    
    
    //  NAME.DUP: Duplicates the top item on the NAME stack. Does not pop its argument (which, if it did, would negate the effect of the duplication!).
    func name_dup() {
        if nameStack.length() > 0 {
            nameStack.dup()
        }
    }
    
    
    //  name_flip()
    func name_flip() {
        nameStack.flip()
    }

    
    //  NAME.FLUSH: Empties the NAME stack.
    func name_flush() {
        nameStack.clear()
    }

    
    // name_isAssigned() is not part of the Push 3.0 specification
    func name_isAssigned() {
        if nameStack.length() > 0 {
            let n = nameStack.pop()!.value as String
            boolStack.push(PushPoint.Boolean(contains(bindings.keys,n)))
        }
    }
    
    
    //  NAME.=: Pushes TRUE if the top two NAMEs are equal, or FALSE otherwise.
    func name_isEqual() {
        if nameStack.length() > 1 {
            let arg2 = nameStack.pop()!.value as String
            let arg1 = nameStack.pop()!.value as String
            boolStack.push(PushPoint.Boolean(arg1 == arg2))
        }
    }
    
    //  NAME.RAND: Pushes a newly generated random NAME.
    func name_new() {
        let uuid = CFUUIDCreateString(nil, CFUUIDCreate(nil))
        nameStack.push(PushPoint.Name("\(uuid)"))
    }


    //  NAME.POP: Pops the NAME stack.
    func name_pop() {
        let discard = nameStack.pop()!
    }

    
    //  NAME.ROT: Rotates the top three items on the NAME stack, pulling the third item out and pushing it on top. This is equivalent to "2 NAME.YANK".
    func name_rotate() {
        nameStack.rotate()
    }
    
    //  NAME.SHOVE: Inserts the top NAME "deep" in the stack, at the position indexed by the top INTEGER.
    func name_shove() {
        if intStack.length() > 0 {
            let d = intStack.pop()!.value as Int
            nameStack.shove(d)
        }
    }


    //  NAME.SWAP: Swaps the top two NAMEs.
    func name_swap() {
        nameStack.swap()
    }

    
    
}
