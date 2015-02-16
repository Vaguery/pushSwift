//
//  Hillclimbing Spike.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 2/16/15.
//  Copyright (c) 2015 Bill Tozier. All rights reserved.
//

import Cocoa
import XCTest
import PushInterpreter

class Hillclimbing_Spike: XCTestCase {
    
    func test_HillclimbingIdea() {
        func newGuy() -> PushAnswer {
            return PushAnswer(length: 100, otherTokens:["(",")","«int»","«bool»","«float»","x"])
        }
        
        // setup "population"
        let popSize = 10
        var answers = [PushAnswer]()
        for i in 1...popSize {
            answers.append(newGuy())
        }
        
        // target symbolic regression function
        func billsBday(x:Int) -> Int {
            return 9 + (11 * x) + (64 * x * x)
        }
        
        for gen in 1...5 {
            // sample and sort
            var x = Int(arc4random_uniform(30) + 1)
            for guy in answers {
                guy.resetWithBindings(["x=\(x)":"\(x)"])
                guy.run()
                if let sortof_returned = guy.interpreter.intStack.pop() {
                    if let val = sortof_returned.description.toInt() {
                        let error = abs(val - billsBday(x))
                        guy.scores["x=\(x)"] = Double(error)
                    }
                } else {
                    guy.scores["x=\(x)"] = 9999999.0
                }
            }
            var sortedAnswers = answers.sorted({$0.scores["x=\(x)"] <= $1.scores["x=\(x)"]})
            
            // report
            for dude in sortedAnswers {
                let s = dude.scores["x=\(x)"]
                println("\(s)")
            }
            
            answers = sortedAnswers
            
            // add more
            for i in 1...popSize {
                let baby = newGuy()
                answers.append(baby)
            }

        }
    }

    
}
