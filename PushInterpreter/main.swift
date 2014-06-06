//
//  main.swift
//  PushInterpreter
//
//  Created by Bill Tozier on 6/4/14.
//  Copyright (c) 2014 Bill Tozier. All rights reserved.
//

import Cocoa

NSApplicationMain(C_ARGC, C_ARGV)

// PushProgramPoints


// Stacks

class PushStack<T> {
    
    var items = T[]()
    
    func push(item: T) {
        items.append(item)
    }
    
    func pop() -> T? {
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
    
    func dup() {
        items.unshare()
        if items.count > 0 {
            let top_one = self.pop()
            let new_one = top_one!
            self.push(top_one!)
            self.push(new_one)              // feels as though this might cause trouble if working byRef
        }
    }
}