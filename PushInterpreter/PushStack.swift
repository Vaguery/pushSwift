//
//  PushStack.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/10/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Foundation

//////////////
// Push Stacks

class PushStack:Printable {
    
    var items:PushPoint[] = []
    
    func push(item: PushPoint) {
        items.append(item)
    }
    
    var description:String {
        return items.reduce("[") {$0 + " \($1.description)"} + " ]"
    }
    
    func pop() -> PushPoint? {
        if items.count == 0 {
            return nil
        } else {
            return items.removeLast()
        }
    }
    
    func length() -> Int {
        return items.count
    }
    
    func swap() {
        if items.count > 1 {
            let old_top = self.pop()
            let old_second = self.pop()
            self.push(old_top!)
            self.push(old_second!)
        }
    }
    
    func clear() {
        items = PushPoint[]()
    }
    
    func dup() {
        items.unshare()
        if items.count > 0 {
            let duped = self.items[items.count - 1]
            self.push(duped.clone())
        }
    }
}
