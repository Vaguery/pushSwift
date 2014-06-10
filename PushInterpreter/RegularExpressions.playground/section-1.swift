// Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

var error : NSError?;
let regex = NSRegularExpression(pattern: "\\b[0-9]+\\b", options: nil, error: &error)
    // check `error' here!
let shouldBeOne = regex.numberOfMatchesInString("66612\n12 331", options: nil, range: NSMakeRange(0, countElements("66612\n12 331")))
let shouldBeZilch = regex.numberOfMatchesInString("food bar", options: nil, range: NSMakeRange(0, countElements("food bar")))

