//
//  pushParser.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/6/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation


// DeepCopyable

@objc protocol DeepCopyable {
    class func deep_copy() -> Self
}



// PushCodePoint

struct PushCodePoint<T> {
    let value:T
    init(value:T) {
        self.value = value
    }
}

//struct PushCodePoint<T:DeepCopyable> {
//    let value:T
//    init(value:T) {
//        self.value = value
//    }
//}


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