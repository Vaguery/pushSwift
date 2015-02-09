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



public class PushOneTimeScenario: PushScenario {
    var score_function:(PushAnswer)->Double

    public init(scorer:(PushAnswer)->Double) {
        score_function = scorer
        super.init()
    }
    
    override public func score(a:PushAnswer)-> Double {
        if let possible_score = a.scores[uniqueID]? {
            return possible_score
        } else {
            let result = score_function(a)
            a.scores[self.uniqueID] = result
            return result
        }
    }
}


public class PushStaticTrainingScenario: PushScenario {
    public var bindings:[String:String]
    var score_function:(PushAnswer)->Double


    public init(scenario_bindings:[String:String],scorer:(PushAnswer)->Double) {
        score_function = scorer
        bindings = scenario_bindings
        super.init()
    }

    override public func score(a:PushAnswer) -> Double {
        if let prior_score = a.scores[uniqueID]? {
            return prior_score
        } else {
            a.resetWithBindings(bindings)
            a.myInterpreter.run()
            
            let score = score_function(a)
            a.scores[self.uniqueID] = score
            return score
        }
    }
    
}