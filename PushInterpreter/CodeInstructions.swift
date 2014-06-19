//
//  CodeInstructions.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/13/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation

extension PushInterpreter {
    func loadCodeInstructions() {
        
        let codeInstructions = [
             "code_append" : self.code_append,
            "code_archive" : self.code_archive,
              "code_begin" : self.code_begin,
                "code_car" : self.code_car,
               "code_cons" : self.code_cons,
                "code_cdr" : self.code_cdr,
     "code_countWithRange" : self.code_countWithRange,
             "code_define" : self.code_define,
         "code_definition" : self.code_definition,
              "code_depth" : self.code_depth,
                 "code_do" : self.code_do,
            "code_doTimes" : self.code_doTimes,
        "code_doWithRange" : self.code_doWithRange,
                "code_dup" : self.code_dup,
                 "code_if" : self.code_if,
               "code_flip" : self.code_flip,
              "code_flush" : self.code_flush,
           "code_fromBool" : self.code_fromBool,
            "code_fromInt" : self.code_fromInt,
          "code_fromFloat" : self.code_fromFloat,
           "code_fromName" : self.code_fromName,
          "code_fromRange" : self.code_fromRange,
             "code_isAtom" : self.code_isAtom,
            "code_isEmpty" : self.code_isEmpty,
            "code_isEqual" : self.code_isEqual,
             "code_length" : self.code_length,
               "code_list" : self.code_list,
                "code_pop" : self.code_pop,
              "code_quote" : self.code_quote,
             "code_rotate" : self.code_rotate,
              "code_shove" : self.code_shove,
               "code_swap" : self.code_swap,
               "code_yank" : self.code_yank,
            "code_yankDup" : self.code_yankDup
        ]
        
        for (k,v) in codeInstructions {
            allPushInstructions[k] = v
        }
        
    }
    
    ////////////////////
    // code instructions
    // via http://faculty.hampshire.edu/lspector/push3-description.html
    
    
    //  CODE.APPEND: Pushes the result of appending the top two pieces of code. If one of the pieces of code is a single instruction or literal (that is, something not surrounded by parentheses) then it is surrounded by parentheses first.
    func code_append() {
        if codeStack.length() > 1 {
            let arg2 = codeStack.pop()!
            let arg1 = codeStack.pop()!
            let plus = PushPoint.Block([arg1, arg2])
            codeStack.push(plus)
        }
    }
    
    //  code_archive()
    func code_archive() {
        if codeStack.length() > 0 {
            let arg = codeStack.pop()!
            execStack.items.insert(arg, atIndex: 0)
        }
    }
    
    
    // code_begin()
    func code_begin() {
        if codeStack.length() > 0 {
            let do_this = codeStack.pop()!
            let block = [
                do_this,
                PushPoint.Instruction("code_begin")
            ]
            execStack.push(PushPoint.Block(block))
        }
    }
    
    
    //  CODE.CAR: Pushes the first item of the list on top of the CODE stack. For example, if the top piece of code is "( A B )" then this pushes "A" (after popping the argument). If the code on top of the stack is not a list then this has no effect. The name derives from the similar Lisp function; a more generic name would be "FIRST".
    func code_car() {
        if codeStack.length() > 0 {
            let arg = codeStack.pop()!.value as PushPoint[]
            if arg.count > 1 {
                let carred = PushPoint.Block([arg[0]])
                codeStack.push(carred)
            }
        }
    }
    
    
    //  CODE.CONS: Pushes the result of "consing" (in the Lisp sense) the second stack item onto the first stack item (which is coerced to a list if necessary). For example, if the top piece of code is "( A B )" and the second piece of code is "X" then this pushes "( X A B )" (after popping the argument).
    func code_cons() {
        if codeStack.length() > 1 {
            let arg2 = codeStack.pop()! as PushPoint
            let arg1 = codeStack.pop()!.value as PushPoint[]
            let consed = [arg2] + arg1
            codeStack.push(PushPoint.Block(consed))
        }
    }

    
    
    //  CODE.CDR: Pushes a version of the list from the top of the CODE stack without its first element. For example, if the top piece of code is "( A B )" then this pushes "( B )" (after popping the argument). If the code on top of the stack is not a list then this pushes the empty list ("( )"). The name derives from the similar Lisp function; a more generic name would be "REST".
    func code_cdr() {
        if codeStack.length() > 0 {
            var arg = codeStack.pop()!.value as PushPoint[]
            if arg.count > 1 {
                let discard = arg.removeAtIndex(0)
                codeStack.push(PushPoint.Block(arg))
            }
        }
    }
    
    
    // code_countWithRange() `( C a (a_stepped..b) :exec_countWithRange C )`
    func code_countWithRange() {
        if codeStack.length() > 0 && rangeStack.length() > 0 {
            let (a,b) = rangeStack.pop()!.value as (Int,Int)
            let do_this = codeStack.pop()!
            
            
            if a == b {
                execStack.push(PushPoint.Integer(a))
                execStack.push(do_this)
            } else {
                let newA = (a < b ? a + 1 : a - 1)
                let block:PushPoint[] = [
                    do_this.clone(),
                    PushPoint.Integer(a),
                    PushPoint.Range(newA,b),
                    PushPoint.Instruction("exec_countWithRange"),
                    do_this]
                execStack.push(PushPoint.Block(block))
            }
        }
    }


    //  CODE.DEFINE: Defines the name on top of the NAME stack as an instruction that will push the top item of the CODE stack onto the EXEC stack.
    func code_define() {
        if codeStack.length() > 0 && nameStack.length() > 0 {
            let point = codeStack.pop()!
            let name = nameStack.pop()!.value as String
            self.bind(name, point: point)
        }
    }
    
    //  CODE.DEFINITION: Pushes the definition associated with the top NAME on the NAME stack (if any) onto the CODE stack. This extracts the definition for inspection/manipulation, rather than for immediate execution (although it may then be executed with a call to CODE.DO or a similar instruction).
    func code_definition() {
        if nameStack.length() > 0 {
            let key = nameStack.pop()!.value as String
            if let val = self.bindings[key] {
                let block = PushPoint.Block([val])
                codeStack.push(block)
            }
        }
    }

    
    
    //  CODE.STACKDEPTH: Pushes the stack depth onto the INTEGER stack.
    func code_depth() {
        let d = codeStack.length()
        intStack.push(PushPoint.Integer(d))
    }
    
    //  code_do()
    func code_do() {
        if codeStack.length() > 0 {
            let do_this = codeStack.pop()!
            execStack.push(do_this)
        }
    }
    
    
    // code_doTimes() pops int b, pushes `( C (1..b) :exec_doWithRange C )`
    func code_doTimes() {
        if codeStack.length() > 0 && intStack.length() > 0 {
            var count = intStack.pop()!.value as Int
            let do_this = codeStack.pop()!
            
            if count == 1 {
                execStack.push(do_this)
            } else if count < 1 {
                // do nothing
            } else {
                let block:PushPoint[] = [
                    do_this.clone(),
                    PushPoint.Range(2,count),
                    PushPoint.Instruction("exec_doWithRange"),
                    do_this]
                execStack.push(PushPoint.Block(block))
            } // otherwise don't do it at all
        }
    }


    // code_doWithRange()
    func code_doWithRange() {
        if codeStack.length() > 0 && rangeStack.length() > 0 {
            let (a,b) = rangeStack.pop()!.value as (Int,Int)
            let do_this = codeStack.pop()!
            
            if a == b {
                execStack.push(do_this)
            } else {
                let newA = (a < b ? a + 1 : a - 1)
                let block:PushPoint[] = [
                    do_this.clone(),
                    PushPoint.Range(newA,b),
                    PushPoint.Instruction("exec_doWithRange"),
                    do_this]
                execStack.push(PushPoint.Block(block))
            }
        }
    }
    
    
    //  CODE.DUP: Duplicates the top item on the CODE stack. Does not pop its argument (which, if it did, would negate the effect of the duplication!).
    func code_dup() {
        codeStack.dup()
    }
    
    
    
    
    //  CODE.FLUSH: Empties the CODE stack.
    func code_flush() {
        codeStack.clear()
    }
    
    
    //  CODE.FROMBOOLEAN: Pops the BOOLEAN stack and pushes the popped item (TRUE or FALSE) onto the CODE stack.
    func code_fromBool() {
        if boolStack.length() > 0 {
            let arg = boolStack.pop()! as PushPoint
            codeStack.push(PushPoint.Block([arg]))
        }
    }
    
    
    //  CODE.FROMINTEGER: Pops the INTEGER stack and pushes the popped integer onto the CODE stack.
    func code_fromInt() {
        if intStack.length() > 0 {
            let arg = intStack.pop()! as PushPoint
            codeStack.push(PushPoint.Block([arg]))
        }
    }


    
    //  CODE.FROMFLOAT: Pops the FLOAT stack and pushes the popped item onto the CODE stack.
    func code_fromFloat() {
        if floatStack.length() > 0 {
            let arg = floatStack.pop()! as PushPoint
            codeStack.push(PushPoint.Block([arg]))
        }
    }

    
    //  CODE.FROMNAME: Pops the NAME stack and pushes the popped item onto the CODE stack.
    func code_fromName() {
        if nameStack.length() > 0 {
            let arg = nameStack.pop()! as PushPoint
            codeStack.push(PushPoint.Block([arg]))
        }
    }
    
    
    //  code_fromRange()
    func code_fromRange() {
        if rangeStack.length() > 0 {
            let arg = rangeStack.pop()! as PushPoint
            codeStack.push(PushPoint.Block([arg]))
        }
    }


    
    
    //  CODE.ATOM: Pushes TRUE onto the BOOLEAN stack if the top piece of code is a single instruction or a literal, and FALSE otherwise (that is, if it is something surrounded by parentheses).
    func code_isAtom() {
        if codeStack.length() > 0 {
            let pts = codeStack.pop()!.value as PushPoint[]
            boolStack.push(PushPoint.Boolean(pts.count == 1))
        }
    }
    
    // code_flip()
    func code_flip() {
        codeStack.flip()
    }
    
    
    //  CODE.IF: If the top item of the BOOLEAN stack is TRUE this recursively executes the second item of the CODE stack; otherwise it recursively executes the first item of the CODE stack. Either way both elements of the CODE stack (and the BOOLEAN value upon which the decision was made) are popped.
    func code_if() {
        if codeStack.length() > 1 && boolStack.length() > 0 {
            let choice = boolStack.pop()!.value as Bool
            let arg2 = codeStack.pop()!
            let arg1 = codeStack.pop()!
            choice ? execStack.push(arg1) : execStack.push(arg2)
        }
    }
    

    // code_isEmpty() is not part of Push 3.0 specification
    func code_isEmpty() {
        if codeStack.length() > 0 {
            let pts = codeStack.pop()!.value as PushPoint[]
            boolStack.push(PushPoint.Boolean(pts.count == 0))
        }
    }
    
    
    //  CODE.=: Pushes TRUE if the top two pieces of CODE are equal, or FALSE otherwise.
    func code_isEqual() {
        if codeStack.length() > 1 {
            let arg2 = codeStack.pop()! as PushPoint
            let arg1 = codeStack.pop()! as PushPoint
            let isSame:Bool = (arg1.description == arg2.description)
            boolStack.push(PushPoint.Boolean(isSame))
        }
    }

    //  CODE.LENGTH: Pushes the length of the top item on the CODE stack onto the INTEGER stack. If the top item is not a list then this pushes a 1. If the top item is a list then this pushes the number of items in the top level of the list; that is, nested lists contribute only 1 to this count, no matter what they contain.
    func code_length() {
        if codeStack.length() > 0 {
            let arg = codeStack.pop()!.value as PushPoint[]
            intStack.push(PushPoint.Integer(arg.count))
        }
    }
    
    //  CODE.LIST: Pushes a list of the top two items of the CODE stack onto the CODE stack.
    func code_list() {
        if codeStack.length() > 1 {
            let arg2 = codeStack.pop()!
            let arg1 = codeStack.pop()!
            codeStack.push(PushPoint.Block([arg1,arg2]))
        }
    }


    //  CODE.POP: Pops the CODE stack.
    func code_pop() {
        let discard = codeStack.pop()
    }
    
    //  CODE.QUOTE: Specifies that the next expression submitted for execution will instead be pushed literally onto the CODE stack. This can be implemented by moving the top item on the EXEC stack onto the CODE stack.
    func code_quote() {
        if execStack.length() > 0 {
            let quoted = execStack.pop()!
            if quoted.isBlock() {
                codeStack.push(quoted)
            } else {
                codeStack.push(PushPoint.Block([quoted]))
            }
        }
    }
    
    //  CODE.ROT: Rotates the top three items on the CODE stack, pulling the third item out and pushing it on top. This is equivalent to "2 CODE.YANK".
    func code_rotate() {
        codeStack.rotate()
    }
    
    //  CODE.SHOVE: Inserts the top piece of CODE "deep" in the stack, at the position indexed by the top INTEGER.
    func code_shove() {
        if intStack.length() > 0 {
            let d = intStack.pop()!.value as Int
            codeStack.shove(d)
        }
    }


    //  CODE.SWAP: Swaps the top two pieces of CODE.
    func code_swap() {
        codeStack.swap()
    }

    //  CODE.YANK: Removes an indexed item from "deep" in the stack and pushes it on top of the stack. The index is taken from the INTEGER stack.
    func code_yank() {
        if intStack.length() > 0 {
            let d = intStack.pop()!.value as Int
            codeStack.yank(d)
        }
    }

    //  CODE.YANKDUP: Pushes a copy of an indexed item "deep" in the stack onto the top of the stack, without removing the deep item. The index is taken from the INTEGER stack.
    func code_yankDup() {
        if intStack.length() > 0 {
            let d = intStack.pop()!.value as Int
            codeStack.yankDup(d)
        }
    }

    
}