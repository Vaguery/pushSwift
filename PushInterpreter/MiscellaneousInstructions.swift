//
//  MiscellaneousInstructions.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/13/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation

extension PushInterpreter {
    func loadMiscellaneousInstructions() {
        
        let miscInstructions = [
            "noop" : self.noop
        ]
        
        for (k,v) in miscInstructions {
            allPushInstructions[k] = v
        }
        
    }
    
    /////////////////////////////
    // miscellaneous instructions
    
    func noop() {}
    
}