// Playground - noun: a place where people can play

import Foundation

let y = 2 + 2

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
}

var intArray = PushStack<Int>()
intArray.push(3)
intArray.push(22)
intArray.push(111)

intArray.items


var i2:Int? = intArray.pop()

var i1:Int? = intArray.pop()

var i0:Int? = intArray.pop()

intArray

var iWhat:Int? = intArray.pop()
