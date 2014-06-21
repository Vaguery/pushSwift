//
//  RangeInstructions.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/13/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation

extension PushInterpreter {
    func loadRangeInstructions() {
        
        let rangeInstructions = [
             "range_archive" : self.range_archive,
               "range_count" : self.range_count,
             "range_countBy" : self.range_countBy,
              "range_define" : self.range_define,
                 "range_dup" : self.range_dup,
                "range_flip" : self.range_flip,
            "range_fromEnds" : self.range_fromEnds,
           "range_fromInner" : self.range_fromInner,
            "range_fromInts" : self.range_fromInts,
           "range_fromOuter" : self.range_fromOuter,
          "range_fromStarts" : self.range_fromStarts,
            "range_fromZero" : self.range_fromZero,
            "range_isClosed" : self.range_isClosed,
            "range_isUpward" : self.range_isUpward,
                 "range_mix" : self.range_mix,
             "range_reverse" : self.range_reverse,
              "range_rotate" : self.range_rotate,
           "range_scaleDown" : self.range_scaleDown,
             "range_scaleUp" : self.range_scaleUp,
               "range_shift" : self.range_shift,
               "range_shove" : self.range_shove,
                "range_size" : self.range_size,
                "range_step" : self.range_step,
              "range_stepBy" : self.range_stepBy,
                "range_swap" : self.range_swap,
              "range_unstep" : self.range_unstep,
                "range_yank" : self.range_yank,
             "range_yankDup" : self.range_yankDup
        ]
        
        for (k,v) in rangeInstructions {
            allPushInstructions[k] = v
        }
        
    }
    
    /////////////////////
    // range instructions
    
    // (ranges are not a feature of Push 3.0, so all these are new)
    
    //  range_archive()
    func range_archive() {
        if rangeStack.length() > 0 {
            let arg = rangeStack.pop()!
            execStack.items.insert(arg, atIndex: 0)
        }
    }

    
    //  range_count() : moves the first bound one closer, unless identical, pushing the old start number to intStack; if a == b, destroys the Range after pushing Int(a)
    func range_count() {
        if rangeStack.length() > 0 {
            let (start,end) = rangeStack.pop()!.value as (Int,Int)
            intStack.push(PushPoint.Integer(start))
            if start < end {
                rangeStack.push(PushPoint.Range(start+1,end))
            } else if start > end {
                rangeStack.push(PushPoint.Range(start-1,end))
            }  // and if they match, it dies
        }
    }
    
    // range_countBy() : moves first bound `N` closer to second, unless identical, where `N` is an Int; if `N < 0`, the first bound moves away form the second; will not cross start and end; if `a == b` (or they cross), it destroys the Range after pushing `Int(a)`
    func range_countBy() {
        if rangeStack.length() > 0 && intStack.length() > 0 {
            let (start,end) = rangeStack.pop()!.value as (Int,Int)
            let delta = intStack.pop()!.value as Int
            
            intStack.push(PushPoint.Integer(start))

            if start == end {return}
            
            let newStart = start + delta
            if (start < end && newStart < end) {
                rangeStack.push(PushPoint.Range(newStart,end))
            } else if (start > end && newStart > end) {
                rangeStack.push(PushPoint.Range(newStart,end))
            }
        }
    }

    
    //  range_define() : pops the top name and assigns the top range as its definition
    func range_define() {
        if rangeStack.length() > 0 && nameStack.length() > 0 {
            let point = rangeStack.pop()!
            let name = nameStack.pop()!.value as String
            self.bind(name, point: point)
        }
    }
    
    
    //  range_dup() : duplicates the top range item
    func range_dup() {
        rangeStack.dup()
    }
    
    //  range_flip() : inverts the range stack, top-for-bottom
    func range_flip() {
        rangeStack.flip()
    }

    //  range_fromEnds() : pops two ranges (a..b) and (c..d) and pushes (b..d)
    func range_fromEnds() {
        if rangeStack.length() > 1 {
            let (a2,b2) = rangeStack.pop()!.value as (Int,Int)
            let (a1,b1) = rangeStack.pop()!.value as (Int,Int)
            rangeStack.push(PushPoint.Range(b1,b2))
        }
    }

    //  range_inner() : pops two ranges (a..b) and (c..d) and pushes (b..c)
    func range_fromInner() {
        if rangeStack.length() > 1 {
            let (a2,b2) = rangeStack.pop()!.value as (Int,Int)
            let (a1,b1) = rangeStack.pop()!.value as (Int,Int)
            rangeStack.push(PushPoint.Range(b1,a2))
        }
    }

    //  range_fromInts() : pops two integers a & b pushes (a..b)
    func range_fromInts() {
        if intStack.length() > 1 {
            let arg2 = intStack.pop()!.value as Int
            let arg1 = intStack.pop()!.value as Int
            rangeStack.push(PushPoint.Range(arg1,arg2))
        }
    }
    
    //  range_fromOuter() : pops two ranges (a..b) and (c..d) and pushes (a..d)
    func range_fromOuter() {
        if rangeStack.length() > 1 {
            let (a2,b2) = rangeStack.pop()!.value as (Int,Int)
            let (a1,b1) = rangeStack.pop()!.value as (Int,Int)
            rangeStack.push(PushPoint.Range(a1,b2))
        }
    }

    
    //  range_fromStarts() : pops two ranges (a..b) and (c..d), and pushes (a..c)
    func range_fromStarts() {
        if rangeStack.length() > 1 {
            let (a2,b2) = rangeStack.pop()!.value as (Int,Int)
            let (a1,b1) = rangeStack.pop()!.value as (Int,Int)
            rangeStack.push(PushPoint.Range(a1,a2))
        }
    }

    
    //  range_fromZero() : pops the top int a, and pushes range (0..a)
    func range_fromZero() {
        if intStack.length() > 0 {
            let arg1 = intStack.pop()!.value as Int
            rangeStack.push(PushPoint.Range(0,arg1))
        }
    }
    
    
    //  range_isClosed(): true if start and end are the same
    func range_isClosed() {
        if rangeStack.length() > 0 {
            let (a,b) = rangeStack.pop()!.value as (Int,Int)
            boolStack.push(PushPoint.Boolean(a==b))
        }
    }

    
    //  range_isUpward() : pops the top range (a..b), and pushes the boolean indicating whether a < b
    func range_isUpward() {
        if rangeStack.length() > 0 {
            let (a,b) = rangeStack.pop()!.value as (Int,Int)
            let isUp = (a < b)
            boolStack.push(PushPoint.Boolean(isUp))
        }
    }

    
    //  range_mix() : pops two ranges (a..b) and (c..d), and pushes (a..d) then (c..b)
    func range_mix() {
        if rangeStack.length() > 1 {
            let (a,b) = rangeStack.pop()!.value as (Int,Int)
            let (c,d) = rangeStack.pop()!.value as (Int,Int)
            rangeStack.push(PushPoint.Range(c,b))
            rangeStack.push(PushPoint.Range(a,d))
        }
    }

    
    //  range_reverse() : pops the top range (a..b) and pushes (b..a)
    func range_reverse() {
        if rangeStack.length() > 0 {
            let (start,end) = rangeStack.pop()!.value as (Int,Int)
            rangeStack.push(PushPoint.Range(end,start))
        }
    }
    
    
    //  range_rotate() : rotates the top three range items so the third is now on top
    func range_rotate() {
        rangeStack.rotate()
    }
    
    
    //  `range_scaleDown()` : pops a range and an Int; divides the Int into both extremes; does nothing if the scale Int is 0
    func range_scaleDown() {
        if rangeStack.length() > 0 && intStack.length() > 0 {
            let scale = intStack.pop()!.value as Int
            let (a,b) = rangeStack.pop()!.value as (Int,Int)
            if scale != 0 {
                rangeStack.push(PushPoint.Range(a/scale, b/scale))
            }
        }
    }
    
    
    //  `range_scaleUp()` : pops a range and an Int; multiplies the Int by both extremes
    func range_scaleUp() {
        if rangeStack.length() > 0 && intStack.length() > 0 {
            let scale = intStack.pop()!.value as Int
            let (a,b) = rangeStack.pop()!.value as (Int,Int)
            rangeStack.push(PushPoint.Range(a*scale, b*scale))
        }
    }

    
    //  `range_shift()` : pops a range and an Int; adds the int to both extremes
    func range_shift() {
        if rangeStack.length() > 0 && intStack.length() > 0 {
            let shift = intStack.pop()!.value as Int
            let (a,b) = rangeStack.pop()!.value as (Int,Int)
            rangeStack.push(PushPoint.Range(a+shift,b+shift))
        }
    }
    

    //  range_shove() : pops an int A and range, and places the range in position (range_stack.count % A)
    func range_shove() {
        if intStack.length() > 0 {
            let d = intStack.pop()!.value as Int
            rangeStack.shove(d)
        }
    }
    
    
    // range_size() : number of steps from a to b, inclusive
    func range_size() {
        if rangeStack.length() > 0 {
            let (start,end) = rangeStack.pop()!.value as (Int,Int)
            intStack.push(PushPoint.Integer(abs(start-end)))
        }
    }
    
    // range_step() : moves the first bound one closer to the second, unless identical; if a == b, destroys the Range
    func range_step() {
        if rangeStack.length() > 0 {
            let (start,end) = rangeStack.pop()!.value as (Int,Int)
            if start < end {
                rangeStack.push(PushPoint.Range(start+1,end))
            } else if start > end {
                rangeStack.push(PushPoint.Range(start-1,end))
            }  // and if they match, it dies
        }
    }
    
    
    // range_stepBy() : moves first bound `N` closer to second, unless identical, where `N` is an `Int`; will not cross start and end; if `N < 0`, the first bound gets farther away; if `a == b` (or crosses), destroys the `Range`
    func range_stepBy() {
        if rangeStack.length() > 0 && intStack.length() > 0 {
            let (start,end) = rangeStack.pop()!.value as (Int,Int)
            let delta = intStack.pop()!.value as Int
            if start == end {return}

            let newStart = start + delta
            if (start < end && newStart < end) {
                rangeStack.push(PushPoint.Range(newStart,end))
            } else if (start > end && newStart > end) {
                rangeStack.push(PushPoint.Range(newStart,end))
            }
        }
    }


    
    //  range_swap() : exchanges the top two items on the range stack
    func range_swap() {
        if rangeStack.length() > 1 {
            rangeStack.swap()
        }
    }
    
    
    // range_unstep() : moves the first bound one farther from the second
    func range_unstep() {
        if rangeStack.length() > 0 {
            let (start,end) = rangeStack.pop()!.value as (Int,Int)
            if start <= end {
                rangeStack.push(PushPoint.Range(start-1,end))
            } else if start > end {
                rangeStack.push(PushPoint.Range(start+1,end))
            }
        }
    }

    
    func range_yank() {
        if intStack.length() > 0 {
            let d = intStack.pop()!.value as Int
            rangeStack.yank(d)
        }
    }
    

    func range_yankDup() {
        if intStack.length() > 0 {
            let d = intStack.pop()!.value as Int
            rangeStack.yankDup(d)
        }
    }

}