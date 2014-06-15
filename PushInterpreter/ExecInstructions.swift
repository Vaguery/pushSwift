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
              "exec_archive" : {self.exec_archive()},
               "exec_define" : {self.exec_define()},
                "exec_depth" : {self.exec_depth()},
                  "exec_dup" : {self.exec_dup()},
                 "exec_flip" : {self.exec_flip()},
                "exec_flush" : {self.exec_flush()},
              "exec_isBlock" : {self.exec_isBlock()},
            "exec_isLiteral" : {self.exec_isLiteral()},
                    "exec_k" : {self.exec_k()},
                  "exec_pop" : {self.exec_pop()}, 
               "exec_rotate" : {self.exec_rotate()},
                "exec_shove" : {self.exec_shove()},
                 "exec_swap" : {self.exec_swap()}
        ]
        
        for (k,v) in execInstructions {
            allPushInstructions[k] = v
        }
        
    }
    
    ////////////////////
    // exec instructions
    // via http://faculty.hampshire.edu/lspector/push3-description.html
    //
    // (pending)
    //    EXEC.=: Pushes TRUE if the top two items on the EXEC stack are equal, or FALSE otherwise.
    //    EXEC.DO*COUNT: An iteration instruction that performs a loop (the body of which is taken from the EXEC stack) the number of times indicated by the INTEGER argument, pushing an index (which runs from zero to one less than the number of iterations) onto the INTEGER stack prior to each execution of the loop body. This is similar to CODE.DO*COUNT except that it takes its code argument from the EXEC stack. This should be implemented as a macro that expands into a call to EXEC.DO*RANGE. EXEC.DO*COUNT takes a single INTEGER argument (the number of times that the loop will be executed) and a single EXEC argument (the body of the loop). If the provided INTEGER argument is negative or zero then this becomes a NOOP. Otherwise it expands into:
    //    ( 0 <1 - IntegerArg> EXEC.DO*RANGE <ExecArg> )
    //    EXEC.DO*RANGE: An iteration instruction that executes the top item on the EXEC stack a number of times that depends on the top two integers, while also pushing the loop counter onto the INTEGER stack for possible access during the execution of the body of the loop. This is similar to CODE.DO*COUNT except that it takes its code argument from the EXEC stack. The top integer is the "destination index" and the second integer is the "current index." First the code and the integer arguments are saved locally and popped. Then the integers are compared. If the integers are equal then the current index is pushed onto the INTEGER stack and the code (which is the "body" of the loop) is pushed onto the EXEC stack for subsequent execution. If the integers are not equal then the current index will still be pushed onto the INTEGER stack but two items will be pushed onto the EXEC stack -- first a recursive call to EXEC.DO*RANGE (with the same code and destination index, but with a current index that has been either incremented or decremented by 1 to be closer to the destination index) and then the body code. Note that the range is inclusive of both endpoints; a call with integer arguments 3 and 5 will cause its body to be executed 3 times, with the loop counter having the values 3, 4, and 5. Note also that one can specify a loop that "counts down" by providing a destination index that is less than the specified current index.
    //    EXEC.DO*TIMES: Like EXEC.DO*COUNT but does not push the loop counter. This should be implemented as a macro that expands into EXEC.DO*RANGE, similarly to the implementation of EXEC.DO*COUNT, except that a call to INTEGER.POP should be tacked on to the front of the loop body code in the call to EXEC.DO*RANGE. This call to INTEGER.POP will remove the loop counter, which will have been pushed by EXEC.DO*RANGE, prior to the execution of the loop body.
    //    EXEC.IF: If the top item of the BOOLEAN stack is TRUE then this removes the second item on the EXEC stack, leaving the first item to be executed. If it is false then it removes the first item, leaving the second to be executed. This is similar to CODE.IF except that it operates on the EXEC stack. This acts as a NOOP unless there are at least two items on the EXEC stack and one item on the BOOLEAN stack.
    //    EXEC.S: The Push implementation of the "S combinator". Pops 3 items from the EXEC stack, which we will call A, B, and C (with A being the first one popped). Then pushes a list containing B and C back onto the EXEC stack, followed by another instance of C, followed by another instance of A.
    //    EXEC.Y: The Push implementation of the "Y combinator". Inserts beneath the top item of the EXEC stack a new item of the form "( EXEC.Y <TopItem> )".
    //    EXEC.YANK: Removes an indexed item from "deep" in the stack and pushes it on top of the stack. The index is taken from the INTEGER stack. This may be thought of as a "DO SOONER" instruction.
    //    EXEC.YANKDUP: Pushes a copy of an indexed item "deep" in the stack onto the top of the stack, without removing the deep item. The index is taken from the INTEGER stack.
    
    
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
    
    //  EXEC.DUP: Duplicates the top item on the EXEC stack. Does not pop its argument (which, if it did, would negate the effect of the duplication!). This may be thought of as a "DO TWICE" instruction.
    func exec_dup() {
        execStack.dup()
    }
    
    
    //  exec_flip()
    func exec_flip() {
        execStack.flip()
    }
    
    
    //  EXEC.FLUSH: Empties the EXEC stack. This may be thought of as a "HALT" instruction.
    func exec_flush() {
        execStack.clear()
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
        let d = execStack.length()
        if d > 1 {
            execStack.items.removeAtIndex(d-2)
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
    
}