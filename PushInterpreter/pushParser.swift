//
//  pushParser.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/6/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation


class PushParser {
    
    var tokens:String[] = []
    
    func parseScript(script:String) {
        self.tokens = script.componentsSeparatedByString(" ").filter(
            {(s1:String) -> Bool in return s1 != ""}
        )
    }
}