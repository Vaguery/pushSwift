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

        loadBooleanInstructions()
        loadCodeInstructions()
        loadExecInstructions()
        loadFloatInstructions()
        loadIntegerInstructions()
        loadMiscellaneousInstructions()
        loadNameInstructions()
        loadRangeInstructions()

        activePushInstructions = []
        for item in allPushInstructions.keys {activePushInstructions.append(item)}
    }

    
    func execute(command:String) {
        if contains(activePushInstructions, command) {
            let do_this = allPushInstructions[command]
            do_this!()
        }
    }
}