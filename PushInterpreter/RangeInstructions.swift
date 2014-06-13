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
             "range_reverse" : {self.range_reverse()}
        ]
        
        for (k,v) in rangeInstructions {
            allPushInstructions[k] = v
        }
        
    }
    
    /////////////////////
    // range instructions
    
    // (ranges are not a feature of Push 3.0)
    
    func range_fromInts() {
        if intStack.length() > 1 {
            let arg2 = intStack.pop()!.value as Int
            let arg1 = intStack.pop()!.value as Int
            rangeStack.push(PushPoint.Range(arg1,arg2))
        }
    }
    
    func range_reverse() {
        if rangeStack.length() > 0 {
            let (start,end) = rangeStack.pop()!.value as (Int,Int)
            rangeStack.push(PushPoint.Range(end,start))
        }
    }

    
}