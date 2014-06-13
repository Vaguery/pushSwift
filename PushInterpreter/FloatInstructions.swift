//
//  FloatInstructions.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/13/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation

extension PushInterpreter {
    func loadFloatInstructions() {
        
        let floatInstructions = [
            "float_abs" : {self.float_abs()}
        ]
        
        for (k,v) in floatInstructions {
            allPushInstructions[k] = v
        }
        
    }
    
    ////////////////////
    // float instructions
    // via http://faculty.hampshire.edu/lspector/push3-description.html
    //
    // (pending)
    //    FLOAT.%: Pushes the second stack item modulo the top stack item. If the top item is zero this acts as a NOOP. The modulus is computed as the remainder of the quotient, where the quotient has first been truncated toward negative infinity. (This is taken from the definition for the generic MOD function in Common Lisp, which is described for example at http://www.lispworks.com/reference/HyperSpec/Body/f_mod_r.htm.)
    //    FLOAT.*: Pushes the product of the top two items.
    //    FLOAT.+: Pushes the sum of the top two items.
    //    FLOAT.-: Pushes the difference of the top two items; that is, the second item minus the top item.
    //    FLOAT./: Pushes the quotient of the top two items; that is, the second item divided by the top item. If the top item is zero this acts as a NOOP.
    //    FLOAT.<: Pushes TRUE onto the BOOLEAN stack if the second item is less than the top item, or FALSE otherwise.
    //    FLOAT.=: Pushes TRUE onto the BOOLEAN stack if the top two items are equal, or FALSE otherwise.
    //    FLOAT.>: Pushes TRUE onto the BOOLEAN stack if the second item is greater than the top item, or FALSE otherwise.
    //    FLOAT.COS: Pushes the cosine of the top item.
    //    FLOAT.DEFINE: Defines the name on top of the NAME stack as an instruction that will push the top item of the FLOAT stack onto the EXEC stack.
    //    FLOAT.DUP: Duplicates the top item on the FLOAT stack. Does not pop its argument (which, if it did, would negate the effect of the duplication!).
    //    FLOAT.FLUSH: Empties the FLOAT stack.
    //    FLOAT.FROMBOOLEAN: Pushes 1.0 if the top BOOLEAN is TRUE, or 0.0 if the top BOOLEAN is FALSE.
    //    FLOAT.FROMINTEGER: Pushes a floating point version of the top INTEGER.
    //    FLOAT.MAX: Pushes the maximum of the top two items.
    //    FLOAT.MIN: Pushes the minimum of the top two items.
    //    FLOAT.POP: Pops the FLOAT stack.
    //    FLOAT.RAND: Pushes a newly generated random FLOAT that is greater than or equal to MIN-RANDOM-FLOAT and less than or equal to MAX-RANDOM-FLOAT.
    //    FLOAT.ROT: Rotates the top three items on the FLOAT stack, pulling the third item out and pushing it on top. This is equivalent to "2 FLOAT.YANK".
    //    FLOAT.SHOVE: Inserts the top FLOAT "deep" in the stack, at the position indexed by the top INTEGER.
    //    FLOAT.SIN: Pushes the sine of the top item.
    //    FLOAT.STACKDEPTH: Pushes the stack depth onto the INTEGER stack.
    //    FLOAT.SWAP: Swaps the top two BOOLEANs.
    //    FLOAT.TAN: Pushes the tangent of the top item.
    //    FLOAT.YANK: Removes an indexed item from "deep" in the stack and pushes it on top of the stack. The index is taken from the INTEGER stack.
    //    FLOAT.YANKDUP: Pushes a copy of an indexed item "deep" in the stack onto the top of the stack, without removing the deep item. The index is taken from the INTEGER stack.
    
    
    //  float_abs() is not part of the Push 3.0 spec
    
    func float_abs() {
        if floatStack.length() > 0 {
            let arg = floatStack.pop()!.value as Double
            floatStack.push(PushPoint.Float(abs(arg)))
        }
    }
    
    
}