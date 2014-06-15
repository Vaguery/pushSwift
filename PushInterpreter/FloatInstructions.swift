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
               "float_abs" : {self.float_abs()},
            "float_define" : {self.float_define()},
              "float_flip" : {self.float_flip()},
          "float_fromBool" : {self.float_fromBool()},
        "float_isPositive" : {self.float_isPositive()},
            "float_rotate" : {self.float_rotate()},
             "float_shove" : {self.float_shove()}
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
    //    FLOAT.DUP: Duplicates the top item on the FLOAT stack. Does not pop its argument (which, if it did, would negate the effect of the duplication!).
    //    FLOAT.FLUSH: Empties the FLOAT stack.
    //    FLOAT.FROMINTEGER: Pushes a floating point version of the top INTEGER.
    //    FLOAT.MAX: Pushes the maximum of the top two items.
    //    FLOAT.MIN: Pushes the minimum of the top two items.
    //    FLOAT.POP: Pops the FLOAT stack.
    //    FLOAT.RAND: Pushes a newly generated random FLOAT that is greater than or equal to MIN-RANDOM-FLOAT and less than or equal to MAX-RANDOM-FLOAT.
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
    
    //  FLOAT.DEFINE: Defines the name on top of the NAME stack as an instruction that will push the top item of the FLOAT stack onto the EXEC stack.
    func float_define() {
        if floatStack.length() > 0 && nameStack.length() > 0 {
            let point = floatStack.pop()!
            let name = nameStack.pop()!.value as String
            self.bind(name, point: point)
        }
    }
    
    
    //  float_flip()
    func float_flip() {
        floatStack.flip()
    }
    
    
    
    //  FLOAT.FROMBOOLEAN: Pushes 1.0 if the top BOOLEAN is TRUE, or 0.0 if the top BOOLEAN is FALSE.
    func float_fromBool() {
        if boolStack.length() > 0 {
            let bit = boolStack.pop()!.value as Bool
            let out = bit ? 1.0 : 0.0
            floatStack.push(PushPoint.Float(out))
        }
    }

    
    // float_isPositive(): replaces Push 3.0 BOOLEAN.FROMFLOAT
    func float_isPositive() {
        if floatStack.length() > 0 {
            let arg = floatStack.pop()!.value as Double
            let q:Bool = (arg >= 0.0)
            boolStack.push(PushPoint.Boolean(q))
        }
    }

    
    //  FLOAT.ROT: Rotates the top three items on the FLOAT stack, pulling the third item out and pushing it on top. This is equivalent to "2 FLOAT.YANK".
    func float_rotate() {
        floatStack.rotate()
    }
    
    //  FLOAT.SHOVE: Inserts the top FLOAT "deep" in the stack, at the position indexed by the top INTEGER.
    func float_shove() {
        if intStack.length() > 0 {
            let d = intStack.pop()!.value as Int
            floatStack.shove(d)
        }
    }

    
}