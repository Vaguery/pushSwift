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
             "range_archive" : {self.range_archive()},
              "range_define" : {self.range_define()},
                "range_flip" : {self.range_flip()},
            "range_fromInts" : {self.range_fromInts()},
            "range_fromZero" : {self.range_fromZero()},
            "range_isUpward" : {self.range_isUpward()},
                 "range_mix" : {self.range_mix()},
             "range_reverse" : {self.range_reverse()},
              "range_rotate" : {self.range_rotate()},
               "range_shove" : {self.range_shove()},
                "range_swap" : {self.range_swap()},
                "range_yank" : {self.range_yank()},
             "range_yankDup" : {self.range_yankDup()}
        ]
        
        for (k,v) in rangeInstructions {
            allPushInstructions[k] = v
        }
        
    }
    
    /////////////////////
    // range instructions
    
    // (ranges are not a feature of Push 3.0, so all these are new)
    
    
    // range_step() : moves the first bound one closer to the second, unless identical; if a == b, destroys the Range
    // range_stepBy() : moves first bound N closer to second, unless identical, where N is an Int; will not cross start and end; if N < 0, the first bound gets farther away; if a == b, destroys the Range
    // range_count() : moves the first bound one closer, unless identical, pushing the old start number to intStack; if a == b, destroys the Range after pushing Int(a)
    // range count_by() : moves first bound N closer to second, unless identical, where N is an Int; if N < 0, the first bound moves away form the second; will not cross start and end; if a == b, destroys the Range after pushing Int(a)
    // range_isClosed(): true if start and end are the same
    // range_size() : number of steps from a to b, inclusive
    // range_starts() : pops two ranges (a..b) and (c..d), and pushes (a..c)
    // range_ends() : pops two ranges (a..b) and (c..d) and pushes (b..d)
    // range_outer() : pops two ranges (a..b) and (c..d) and pushes (a..d)
    // range_inner() : pops two ranges (a..b) and (c..d) and pushes (b..c)
    // range_split() : pops (a..b) and an Int; if the Int (x) lies within (a..b), produces (a..x) and (x..b)
    // range_median() : pops (a..b), pushes Int(a+b/2)
    // range_contract() : pops (a..b), pushes new Range with both extremes 1 step closer; destroys Range if a==b
    // range_contractBy() : pops (a..b) and an Int N, pushes new Range with both extremes N steps closer; if N < 0, both extremes move apart by N each; destroys Range if a==b
    // range_unstep() : moves the first bound one farther from the second
    // range_isOverlapping() : pops two ranges; pushes T if either overlaps the other at all, regardless of direction of either
    // range_isSubset() : pops two ranges; pushes T if they are both the same direction, AND one is entirely within the other
    // range_shift() : pops a range and an Int; adds the int to both extremes
    // range_scale() : pops a range and an Int; multiples the int by both extremes
    
    
    //  range_archive()
    func range_archive() {
        if rangeStack.length() > 0 {
            let arg = rangeStack.pop()!
            execStack.items.insert(arg, atIndex: 0)
        }
    }

    
    
    func range_define() {
        if rangeStack.length() > 0 && nameStack.length() > 0 {
            let point = rangeStack.pop()!
            let name = nameStack.pop()!.value as String
            self.bind(name, point: point)
        }
    }
    
    
    func range_flip() {
        rangeStack.flip()
    }

    
    func range_fromInts() {
        if intStack.length() > 1 {
            let arg2 = intStack.pop()!.value as Int
            let arg1 = intStack.pop()!.value as Int
            rangeStack.push(PushPoint.Range(arg1,arg2))
        }
    }
    
    
    func range_fromZero() {
        if intStack.length() > 0 {
            let arg1 = intStack.pop()!.value as Int
            rangeStack.push(PushPoint.Range(0,arg1))
        }
    }
    
    
    func range_isUpward() {
        if rangeStack.length() > 0 {
            let (a,b) = rangeStack.pop()!.value as (Int,Int)
            let isUp = (a < b)
            boolStack.push(PushPoint.Boolean(isUp))
        }
    }

    
    func range_mix() {
        if rangeStack.length() > 1 {
            let (a,b) = rangeStack.pop()!.value as (Int,Int)
            let (c,d) = rangeStack.pop()!.value as (Int,Int)
            rangeStack.push(PushPoint.Range(c,b))
            rangeStack.push(PushPoint.Range(a,d))
        }
    }

    
    func range_reverse() {
        if rangeStack.length() > 0 {
            let (start,end) = rangeStack.pop()!.value as (Int,Int)
            rangeStack.push(PushPoint.Range(end,start))
        }
    }
    
    
    func range_rotate() {
        rangeStack.rotate()
    }
    
    
    func range_shove() {
        if intStack.length() > 0 {
            let d = intStack.pop()!.value as Int
            rangeStack.shove(d)
        }
    }
    
    
    func range_swap() {
        if rangeStack.length() > 1 {
            rangeStack.swap()
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