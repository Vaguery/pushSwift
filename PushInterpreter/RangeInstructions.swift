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
            "range_fromInts" : {self.range_fromInts()},
            "range_fromZero" : {self.range_fromZero()},
            "range_isUpward" : {self.range_isUpward()},
                 "range_mix" : {self.range_mix()},
             "range_reverse" : {self.range_reverse()},
              "range_rotate" : {self.range_rotate()}
        ]
        
        for (k,v) in rangeInstructions {
            allPushInstructions[k] = v
        }
        
    }
    
    /////////////////////
    // range instructions
    
    // (ranges are not a feature of Push 3.0, so all these are new)
    
    
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
    
    func range_reverse() {
        if rangeStack.length() > 0 {
            let (start,end) = rangeStack.pop()!.value as (Int,Int)
            rangeStack.push(PushPoint.Range(end,start))
        }
    }
    
    func range_rotate() {
        rangeStack.rotate()
    }
    
    
    func range_mix() {
        if rangeStack.length() > 1 {
            let (a,b) = rangeStack.pop()!.value as (Int,Int)
            let (c,d) = rangeStack.pop()!.value as (Int,Int)
            rangeStack.push(PushPoint.Range(c,b))
            rangeStack.push(PushPoint.Range(a,d))
        }
    }
    
    func range_isUpward() {
        if rangeStack.length() > 0 {
            let (a,b) = rangeStack.pop()!.value as (Int,Int)
            let isUp = (a < b)
            boolStack.push(PushPoint.Boolean(isUp))
        }
    }

    
}