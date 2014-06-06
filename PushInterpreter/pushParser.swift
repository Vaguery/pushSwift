//
//  pushParser.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/6/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation


// DeepCopyable protocol

protocol DeepCopyable {
    func deep_copy() -> Self
}



// Adding DeepCopyable conformance for Int, Bool, Double types

extension Int: DeepCopyable {
    func deep_copy() -> Int {return self}
}

extension Bool: DeepCopyable {
    func deep_copy() -> Bool {return self}
}

extension Double: DeepCopyable {
    func deep_copy() -> Double {return self}
}



// PushCodePoint

struct PushCodePoint<T:DeepCopyable> {
    let value:T
    init(value:T) {
        self.value = value.deep_copy()
    }
}




//PushParser

class PushParser {
    
    var tokens:String[] = []
    
    func parseScript(script:String) {
        self.tokens = script.componentsSeparatedByCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
            ).filter(
                {(s1:String) -> Bool in return s1 != ""}
            )
    }
}