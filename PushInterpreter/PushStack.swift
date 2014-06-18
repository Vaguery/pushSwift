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
    
    
    func clear() {
        items = PushPoint[]()
    }

    
    var description:String {
        return items.reduce("[") {$0 + " \($1.description)"} + " ]"
    }
    
    
    func dup() {
        if items.count > 0 {
            let duped = self.items[items.count - 1]
            self.push(duped.clone())
        }
    }

    
    func flip() {
        if items.count > 1 {
            items = items.reverse()
        }
    }
    
    
    func length() -> Int {
        return items.count
    }
    

    func pop() -> PushPoint? {
        if items.count == 0 {
            return nil
        } else {
            return items.removeLast()
        }
    }
    
    
    func push(item: PushPoint) {
        items.append(item)
    }

    func rotate() {
        let c = items.count
        switch c {
        case 0,1:
            break
        case 2:
            self.swap()
        default:
            let top = self.pop()!
            let second = self.pop()!
            let third = self.pop()!
            self.push(second)
            self.push(top)
            self.push(third)
        }
    }
    
    
    func shove(new_depth:Int) {
        if items.count > 1 {  // if length is 1, nothing will happen!
            var d = new_depth % items.count
            if d < 0 { d = items.count + d}
            let pt = self.pop()!
            self.items.insert(pt, atIndex: d)
        }
    }

    
    func swap() {
        if items.count > 1 {
            let old_top = self.pop()
            let old_second = self.pop()
            self.push(old_top!)
            self.push(old_second!)
        }
    }
    
    
    func yank(new_depth:Int) {
        if items.count > 1 {  // if length is 1, nothing will happen!
            var d = new_depth % items.count
            if d < 0 { d = items.count + d}
            let pt = self.items.removeAtIndex(d)
            self.push(pt)
        }
    }
    
    func yankDup(new_depth:Int) {
        if items.count > 1 {  // if length is 1, nothing will happen!
            var d = new_depth % items.count
            if d < 0 { d = items.count + d}
            let pt = self.items[d]
            self.push(pt.clone())
        }
    }


    
    
}
