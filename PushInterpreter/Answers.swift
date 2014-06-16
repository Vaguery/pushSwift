//
//  Answers.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/16/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation



func randomIndexFromArray(array:AnyObject[]) -> Int {
    return Int(arc4random_uniform(UInt32(array.count)))
}



class Answer : PushInterpreter {
    
    
}
