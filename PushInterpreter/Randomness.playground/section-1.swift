// Playground - noun: a place where people can play

import Cocoa
import Foundation

let a = ["a", "b", "c", "d", "e", "f", "1", "2", "3", "+", "-", "(", ")"]

let length = a.count

var which = arc4random_uniform(UInt32(length))

var s = ""

for i in 1..20 {
    which = arc4random_uniform(UInt32(length))
    s += "\( a[Int(which)] ) "
}

s