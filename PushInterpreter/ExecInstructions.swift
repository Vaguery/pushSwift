//
//  CodeInstructions.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/13/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation

extension PushInterpreter {
    func loadExecInstructions() {
        
        let execInstructions = [
              "exec_archive" : self.exec_archive,
       "exec_countWithRange" : self.exec_countWithRange,
               "exec_define" : self.exec_define,
                "exec_depth" : self.exec_depth,
              "exec_doTimes" : self.exec_doTimes,
          "exec_doWithRange" : self.exec_doWithRange,
                  "exec_dup" : self.exec_dup,
                "exec_equal" : self.exec_equal,
                 "exec_flip" : self.exec_flip,
                "exec_flush" : self.exec_flush,
                   "exec_if" : self.exec_if,
              "exec_isBlock" : self.exec_isBlock,
            "exec_isLiteral" : self.exec_isLiteral,
                    "exec_k" : self.exec_k,
                  "exec_pop" : self.exec_pop,
               "exec_rotate" : self.exec_rotate,
                    "exec_s" : self.exec_s,
                "exec_shove" : self.exec_shove,
                 "exec_swap" : self.exec_swap,
                    "exec_y" : self.exec_y,
                 "exec_yank" : self.exec_yank,
              "exec_yankDup" : self.exec_yankDup
        ]
        
        for (k,v) in execInstructions {
            allPushInstructions[k] = v
        }
        
    }
    
    ////////////////////
    // exec instructions
    // via http://faculty.hampshire.edu/lspector/push3-description.html
    //
    
    
    //  exec_archive()
    func exec_archive() {
        if execStack.length() > 1 {
            let arg = execStack.pop()!
            execStack.items.insert(arg, atIndex: 0)
        }
    }
    

    
    //  EXEC.DEFINE: Defines the name on top of the NAME stack as an instruction that will push the top item of the EXEC stack back onto the EXEC stack.
    func exec_define() {
        if execStack.length() > 0 && nameStack.length() > 0 {
            let point = execStack.pop()!
            let name = nameStack.pop()!.value as String
            self.bind(name, point: point)
        }
    }

    
    
    //  EXEC.STACKDEPTH: Pushes the stack depth onto the INTEGER stack.
    func exec_depth() {
        let d = execStack.length()
        intStack.push(PushPoint.Integer(d))
    }
    
    
    // exec_countWithRange() `( C a (a_stepped..b) :exec_countWithRange C )`
    func exec_countWithRange() {
        if execStack.length() > 0 && rangeStack.length() > 0 {
            let (a,b) = rangeStack.pop()!.value as (Int,Int)
            let do_this = execStack.pop()!
            
            
            if a == b {
                execStack.push(PushPoint.Integer(a))
                execStack.push(do_this)
            } else {
                let newA = (a < b ? a + 1 : a - 1)
                let block:[PushPoint] = [
                    do_this.clone(),
                    PushPoint.Integer(a),
                    PushPoint.Range(newA,b),
                    PushPoint.Instruction("exec_countWithRange"),
                    do_this]
                execStack.push(PushPoint.Block(block))
            }
        }
    }
    
    
    // exec_doTimes() pops int b, pushes `( C (1..b) :exec_doWithRange C )`
    func exec_doTimes() {
        if execStack.length() > 0 && intStack.length() > 0 {
            var count = intStack.pop()!.value as Int
            let do_this = execStack.pop()!

            if count == 1 {
                execStack.push(do_this)
            } else if count < 1 {
                // do nothing
            } else {
                let block:[PushPoint] = [
                    do_this.clone(),
                    PushPoint.Range(2,count),
                    PushPoint.Instruction("exec_doWithRange"),
                    do_this]
                execStack.push(PushPoint.Block(block))
            } // otherwise don't do it at all
        }
    }
    
    
    // exec_doWithRange() `( C (a_stepped..b) :exec_countWithRange C )`
    func exec_doWithRange() {
        if execStack.length() > 0 && rangeStack.length() > 0 {
            let (a,b) = rangeStack.pop()!.value as (Int,Int)
            let do_this = execStack.pop()!
            
            
            if a == b {
                execStack.push(do_this)
            } else {
                let newA = (a < b ? a + 1 : a - 1)
                let block:[PushPoint] = [
                    do_this.clone(),
                    PushPoint.Range(newA,b),
                    PushPoint.Instruction("exec_doWithRange"),
                    do_this]
                execStack.push(PushPoint.Block(block))
            }
        }
    }

    
    
    //  EXEC.DUP: Duplicates the top item on the EXEC stack. Does not pop its argument (which, if it did, would negate the effect of the duplication!). This may be thought of as a "DO TWICE" instruction.
    func exec_dup() {
        execStack.dup()
    }
    
    //  EXEC.=: Pushes TRUE if the top two items on the EXEC stack are equal, or FALSE otherwise.
    func exec_equal() {
        if execStack.length() > 1 {
            let describe2 = execStack.pop()!.description
            let describe1 = execStack.pop()!.description
            boolStack.push(PushPoint.Boolean((describe1 == describe2)))
        }
    }
    
    
    //  exec_flip()
    func exec_flip() {
        execStack.flip()
    }
    
    
    //  EXEC.FLUSH: Empties the EXEC stack. This may be thought of as a "HALT" instruction.
    func exec_flush() {
        execStack.clear()
    }
    
    //  EXEC.IF: If the top item of the BOOLEAN stack is TRUE then this removes the second item on the EXEC stack, leaving the first item to be executed. If it is false then it removes the first item, leaving the second to be executed. This is similar to CODE.IF except that it operates on the EXEC stack. This acts as a NOOP unless there are at least two items on the EXEC stack and one item on the BOOLEAN stack.
    func exec_if() {
        if execStack.length() > 1 && boolStack.length() > 0 {
            let choice = boolStack.pop()!.value as Bool
            let arg2 = execStack.pop()!
            let arg1 = execStack.pop()!
            choice ? execStack.push(arg1) : execStack.push(arg2)
        }
    }

    
    //  exec_isBlock() is not part of the Push 3.0 spec
    func exec_isBlock() {
        if execStack.length() > 0 {
            let arg = execStack.pop()! as PushPoint
            boolStack.push(PushPoint.Boolean(arg.isBlock()))
        }
    }

    
    //  exec_isLiteral() is not part of the Push 3.0 spec
    func exec_isLiteral() {
        if execStack.length() > 0 {
            let arg = execStack.pop()! as PushPoint
            boolStack.push(PushPoint.Boolean(!arg.isBlock()))
        }
    }
    
    
    // EXEC.K: The Push implementation of the "K combinator". Removes the second item on the EXEC stack.
    func exec_k() {
        if execStack.length() > 1 {
            let keep = execStack.pop()!
            let discard = execStack.pop()!
            execStack.push(keep)
        }
    }
    
    //  EXEC.POP: Pops the EXEC stack. This may be thought of as a "DONT" instruction.
    func exec_pop() {
        let discard = execStack.pop()
    }

    //  EXEC.ROT: Rotates the top three items on the EXEC stack, pulling the third item out and pushing it on top. This is equivalent to "2 EXEC.YANK".
    func exec_rotate() {
        execStack.rotate()
    }
    
    
    //  EXEC.S: The Push implementation of the "S combinator". Pops 3 items from the EXEC stack, which we will call A, B, and C (with A being the first one popped). Then pushes a list containing B and C back onto the EXEC stack, followed by another instance of C, followed by another instance of A.
    func exec_s() {
        if execStack.length() > 2 {
            let (a,b,c) = (execStack.pop()!,execStack.pop()!,execStack.pop()!)
            execStack.push(PushPoint.Block([b,c.clone()]))
            execStack.push(c)
            execStack.push(a)
        }
    }

    
    //  EXEC.SHOVE: Inserts the top EXEC item "deep" in the stack, at the position indexed by the top INTEGER. This may be thought of as a "DO LATER" instruction.
    func exec_shove() {
        if intStack.length() > 0 {
            let d = intStack.pop()!.value as Int
            execStack.shove(d)
        }
    }

    
    //  EXEC.SWAP: Swaps the top two items on the EXEC stack.
    func exec_swap() {
        execStack.swap()
    }
    
    
    //  EXEC.Y: The Push implementation of the "Y combinator". Inserts beneath the top item of the EXEC stack a new item of the form "( EXEC.Y <TopItem> )".
    func exec_y() {
        if execStack.length() > 0 {
            let forever = execStack.pop()!
            execStack.push(PushPoint.Block(
                [PushPoint.Instruction("exec_y"),forever.clone()]))
            execStack.push(forever)
        }
    }

    
    //  EXEC.YANK: Removes an indexed item from "deep" in the stack and pushes it on top of the stack. The index is taken from the INTEGER stack. This may be thought of as a "DO SOONER" instruction.
    func exec_yank() {
        if intStack.length() > 0 {
            let d = intStack.pop()!.value as Int
            execStack.yank(d)
        }
    }

    //  EXEC.YANKDUP: Pushes a copy of an indexed item "deep" in the stack onto the top of the stack, without removing the deep item. The index is taken from the INTEGER stack.
    func exec_yankDup() {
        if intStack.length() > 0 {
            let d = intStack.pop()!.value as Int
            execStack.yankDup(d)
        }
    }

    
}