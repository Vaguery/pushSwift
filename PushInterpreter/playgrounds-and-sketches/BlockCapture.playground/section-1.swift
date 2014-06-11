// Playground - noun: a place where people can play

import Foundation

var script = "( ) ( 1 ) ( 2 ) ) 3 ) 4"

var tokens = script.componentsSeparatedByCharactersInSet(
    NSCharacterSet.whitespaceAndNewlineCharacterSet()
    ).filter(
        {(s1:String) -> Bool in return s1 != ""}
)


// assuming a block has already been detected

func grabRestOfBlock(inout t:String[]) -> String[]? {
    var new_block:String[] = ["("]
    var balance = 1
    while balance > 0 && t.count > 0 {
        let token = t[0]
        switch token {
            case "(":
                balance += 1
            case ")":
                balance -= 1
            default:
                balance += 0
        }
        new_block += t.removeAtIndex(0)
        if balance == 0 { break }
    }
    
    if balance > 0 {
        new_block += Array(count:balance,repeatedValue:")")
    }
    return new_block
}

let test = grabRestOfBlock(&tokens)
tokens
