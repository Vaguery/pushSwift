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
            "name_isAssigned" : {self.name_isAssigned()}
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

//        NAME.=: Pushes TRUE if the top two NAMEs are equal, or FALSE otherwise.
//        NAME.DUP: Duplicates the top item on the NAME stack. Does not pop its argument (which, if it did, would negate the effect of the duplication!).
//        NAME.FLUSH: Empties the NAME stack.
//        NAME.POP: Pops the NAME stack.
//        NAME.QUOTE: Sets a flag indicating that the next name encountered will be pushed onto the NAME stack (and not have its associated value pushed onto the EXEC stack), regardless of whether or not it has a definition. Upon encountering such a name and pushing it onto the NAME stack the flag will be cleared (whether or not the pushed name had a definition).
//        NAME.RAND: Pushes a newly generated random NAME.
//        NAME.RANDBOUNDNAME: Pushes a randomly selected NAME that already has a definition.
//        NAME.ROT: Rotates the top three items on the NAME stack, pulling the third item out and pushing it on top. This is equivalent to "2 NAME.YANK".
//        NAME.SHOVE: Inserts the top NAME "deep" in the stack, at the position indexed by the top INTEGER.
//        NAME.STACKDEPTH: Pushes the stack depth onto the INTEGER stack.
//        NAME.SWAP: Swaps the top two NAMEs.
//        NAME.YANK: Removes an indexed item from "deep" in the stack and pushes it on top of the stack. The index is taken from the INTEGER stack.
//        NAME.YANKDUP: Pushes a copy of an indexed item "deep" in the stack onto the top of the stack, without removing the deep item. The index is taken from the INTEGER stack.

    
    // name_isAssigned() is not part of the Push 3.0 specification
    func name_isAssigned() {
        if nameStack.length() > 0 {
            let n = nameStack.pop()!.value as String
            boolStack.push(PushPoint.Boolean(contains(bindings.keys,n)))
        }
    }
    
    
}
