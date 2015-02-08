//
//  Evaluator.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 2/8/15.
//  Copyright (c) 2015 Bill Tozier. All rights reserved.
//

import Foundation


public class PushScenario {
    public var uniqueID:NSUUID

    public init() {
        uniqueID = NSUUID()
    }
    
    public func score(PushAnswer) -> Double {
        return 0.0
    }
}



public class PushLengthScenario: PushScenario {
    override public init() {
        super.init()
    }
    
    override public func score(a:PushAnswer) -> Double {
        if let possible_score = a.scores[uniqueID]? {
            return possible_score
        } else {
            let score = Double(a.template.count)
            a.scores[self.uniqueID] = score
            return score
        }
    }
}