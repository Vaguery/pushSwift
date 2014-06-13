//
//  PushInstructions.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/10/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation



extension PushInterpreter {
    
    
    func loadActiveInstructions() {
        allPushInstructions.removeAll()
        loadIntegerInstructions()
        loadMiscellaneousInstructions()
        loadBooleanInstructions()
        
        activePushInstructions = []
        for item in allPushInstructions.keys {activePushInstructions += item}
    }

    
    func execute(command:String) {
        if contains(activePushInstructions, command) {
            let do_this = allPushInstructions[command]
            do_this!()
        }
    }
}