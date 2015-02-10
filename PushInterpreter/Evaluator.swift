//
//  Evaluator.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 2/8/15.
//  Copyright (c) 2015 Bill Tozier. All rights reserved.
//

import Foundation


public class PushScenario {

    public init() {
    }
    
    public func score(PushAnswer) -> Double {
        return 0.0
    }
}



public class PushOneTimeScenario: PushScenario {
    var score_function:(PushAnswer)->Double
    public var name:String

    public init(name:String,
            scorer:(PushAnswer)->Double) {
        self.name = name
        score_function = scorer
    }
    
    override public func score(a:PushAnswer)-> Double {
        if let possible_score = a.scores[self.name]? {
            return possible_score
        } else {
            let result = score_function(a)
            a.scores[self.name] = result
            return result
        }
    }
}



public class PushStaticTrainingScenario: PushScenario {
    public var name:String
    public var bindings:[String:String]
    var score_function:(PushAnswer)->Double


    public init(name:String,
            scenario_bindings:[String:String],
            scorer:(PushAnswer)->Double) {
        self.name = name + " \(scenario_bindings)"
        score_function = scorer
        bindings = scenario_bindings
    }

    override public func score(a:PushAnswer) -> Double {
        if let prior_score = a.scores[self.name]? {
            return prior_score
        } else {
            a.resetWithBindings(bindings)
            a.interpreter.run()
            
            let result = score_function(a)
            a.scores[self.name] = result
            return result
        }
    }
}