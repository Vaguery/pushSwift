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
             "code_append" : {self.code_append()},
            "code_archive" : {self.code_archive()},
                "code_car" : {self.code_car()},
               "code_cons" : {self.code_cons()},
                "code_cdr" : {self.code_cdr()},
             "code_define" : {self.code_define()},
         "code_definition" : {self.code_definition()},
              "code_depth" : {self.code_depth()},
                "code_dup" : {self.code_dup()},
               "code_flip" : {self.code_flip()},
              "code_flush" : {self.code_flush()},
           "code_fromBool" : {self.code_fromBool()},
            "code_fromInt" : {self.code_fromInt()},
          "code_fromFloat" : {self.code_fromFloat()},
           "code_fromName" : {self.code_fromName()},
          "code_fromRange" : {self.code_fromRange()},
             "code_isAtom" : {self.code_isAtom()},
            "code_isEmpty" : {self.code_isEmpty()},
            "code_isEqual" : {self.code_isEqual()},
             "code_length" : {self.code_length()},
                "code_pop" : {self.code_pop()},
              "code_quote" : {self.code_quote()},
             "code_rotate" : {self.code_rotate()},
              "code_shove" : {self.code_shove()},
               "code_swap" : {self.code_swap()},
               "code_yank" : {self.code_yank()},
            "code_yankDup" : {self.code_yankDup()}
        ]
        
        for (k,v) in codeInstructions {
            allPushInstructions[k] = v
        }
        
    }
    
    ////////////////////
    // code instructions
    // via http://faculty.hampshire.edu/lspector/push3-description.html
    //
    //  (skipped)
    //  CODE.NOOP: Does nothing.
    //  (see noop() instruction)
    //
    // (pending)
    //
    //    CODE.CONTAINER: Pushes the "container" of the second CODE stack item within the first CODE stack item onto the CODE stack. If second item contains the first anywhere (i.e. in any nested list) then the container is the smallest sub-list that contains but is not equal to the first instance. For example, if the top piece of code is "( B ( C ( A ) ) ( D ( A ) ) )" and the second piece of code is "( A )" then this pushes ( C ( A ) ). Pushes an empty list if there is no such container.
    //    CODE.CONTAINS: Pushes TRUE on the BOOLEAN stack if the second CODE stack item contains the first CODE stack item anywhere (e.g. in a sub-list).
    //    CODE.DISCREPANCY: Pushes a measure of the discrepancy between the top two CODE stack items onto the INTEGER stack. This will be zero if the top two items are equivalent, and will be higher the 'more different' the items are from one another. The calculation is as follows:
    //    1. Construct a list of all of the unique items in both of the lists (where uniqueness is determined by equalp). Sub-lists and atoms all count as items.
    //    2. Initialize the result to zero.
    //    3. For each unique item increment the result by the difference between the number of occurrences of the item in the two pieces of code.
    //    4. Push the result.
    //    CODE.DO: Recursively invokes the interpreter on the program on top of the CODE stack. After evaluation the CODE stack is popped; normally this pops the program that was just executed, but if the expression itself manipulates the stack then this final pop may end up popping something else.
    //    CODE.DO*: Like CODE.DO but pops the stack before, rather than after, the recursive execution.
    //    CODE.DO*COUNT: An iteration instruction that performs a loop (the body of which is taken from the CODE stack) the number of times indicated by the INTEGER argument, pushing an index (which runs from zero to one less than the number of iterations) onto the INTEGER stack prior to each execution of the loop body. This should be implemented as a macro that expands into a call to CODE.DO*RANGE. CODE.DO*COUNT takes a single INTEGER argument (the number of times that the loop will be executed) and a single CODE argument (the body of the loop). If the provided INTEGER argument is negative or zero then this becomes a NOOP. Otherwise it expands into:
    //    ( 0 <1 - IntegerArg> CODE.QUOTE <CodeArg> CODE.DO*RANGE )
    //    CODE.DO*RANGE: An iteration instruction that executes the top item on the CODE stack a number of times that depends on the top two integers, while also pushing the loop counter onto the INTEGER stack for possible access during the execution of the body of the loop. The top integer is the "destination index" and the second integer is the "current index." First the code and the integer arguments are saved locally and popped. Then the integers are compared. If the integers are equal then the current index is pushed onto the INTEGER stack and the code (which is the "body" of the loop) is pushed onto the EXEC stack for subsequent execution. If the integers are not equal then the current index will still be pushed onto the INTEGER stack but two items will be pushed onto the EXEC stack -- first a recursive call to CODE.DO*RANGE (with the same code and destination index, but with a current index that has been either incremented or decremented by 1 to be closer to the destination index) and then the body code. Note that the range is inclusive of both endpoints; a call with integer arguments 3 and 5 will cause its body to be executed 3 times, with the loop counter having the values 3, 4, and 5. Note also that one can specify a loop that "counts down" by providing a destination index that is less than the specified current index.
    //    CODE.DO*TIMES: Like CODE.DO*COUNT but does not push the loop counter. This should be implemented as a macro that expands into CODE.DO*RANGE, similarly to the implementation of CODE.DO*COUNT, except that a call to INTEGER.POP should be tacked on to the front of the loop body code in the call to CODE.DO*RANGE. This call to INTEGER.POP will remove the loop counter, which will have been pushed by CODE.DO*RANGE, prior to the execution of the loop body.
    //    CODE.EXTRACT: Pushes the sub-expression of the top item of the CODE stack that is indexed by the top item of the INTEGER stack. The indexing here counts "points," where each parenthesized expression and each literal/instruction is considered a point, and it proceeds in depth first order. The entire piece of code is at index 0; if it is a list then the first item in the list is at index 1, etc. The integer used as the index is taken modulo the number of points in the overall expression (and its absolute value is taken in case it is negative) to ensure that it is within the meaningful range.
    //    CODE.IF: If the top item of the BOOLEAN stack is TRUE this recursively executes the second item of the CODE stack; otherwise it recursively executes the first item of the CODE stack. Either way both elements of the CODE stack (and the BOOLEAN value upon which the decision was made) are popped.
    //    CODE.INSERT: Pushes the result of inserting the second item of the CODE stack into the first item, at the position indexed by the top item of the INTEGER stack (and replacing whatever was there formerly). The indexing is computed as in CODE.EXTRACT.
    //    CODE.LIST: Pushes a list of the top two items of the CODE stack onto the CODE stack.
    //    CODE.MEMBER: Pushes TRUE onto the BOOLEAN stack if the second item of the CODE stack is a member of the first item (which is coerced to a list if necessary). Pushes FALSE onto the BOOLEAN stack otherwise.
    //    CODE.NTH: Pushes the nth element of the expression on top of the CODE stack (which is coerced to a list first if necessary). If the expression is an empty list then the result is an empty list. N is taken from the INTEGER stack and is taken modulo the length of the expression into which it is indexing.
    //    CODE.NTHCDR: Pushes the nth "CDR" (in the Lisp sense) of the expression on top of the CODE stack (which is coerced to a list first if necessary). If the expression is an empty list then the result is an empty list. N is taken from the INTEGER stack and is taken modulo the length of the expression into which it is indexing. A "CDR" of a list is the list without its first element.
    //    CODE.NULL: Pushes TRUE onto the BOOLEAN stack if the top item of the CODE stack is an empty list, or FALSE otherwise.
    //    CODE.POSITION: Pushes onto the INTEGER stack the position of the second item on the CODE stack within the first item (which is coerced to a list if necessary). Pushes -1 if no
    //    match is found.
    //    CODE.RAND: Pushes a newly-generated random program onto the CODE stack. The limit for the size of the expression is taken from the INTEGER stack; to ensure that it is in the appropriate range this is taken modulo the value of the MAX-POINTS-IN-RANDOM-EXPRESSIONS parameter and the absolute value of the result is used.
    //    CODE.SIZE: Pushes the number of "points" in the top piece of CODE onto the INTEGER stack. Each instruction, literal, and pair of parentheses counts as a point.
    //    CODE.SUBST: Pushes the result of substituting the third item on the code stack for the second item in the first item. As of this writing this is implemented only in the Lisp implementation, within which it relies on the Lisp "subst" function. As such, there are several problematic possibilities; for example "dotted-lists" can result in certain cases with empty-list arguments. If any of these problematic possibilities occurs the stack is left unchanged.
    
    //  (skipped)
    //  CODE.INSTRUCTIONS: Pushes a list of all active instructions in the interpreter's current configuration.


    
    
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