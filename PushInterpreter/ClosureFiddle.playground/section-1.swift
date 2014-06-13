// Playground - noun: a place where people can play

import Cocoa

var counter = 99

func up() {
    counter += 7
}

up()
up()

func down() {
    counter -= 11
}

down(); counter


//////

let options:Dictionary<Int,(Void -> Void)> = [1:{up()}, 2:{down()}]

var changer = options[1]

changer!()
counter


changer = options[2]

changer!()
counter

changer!()
counter

