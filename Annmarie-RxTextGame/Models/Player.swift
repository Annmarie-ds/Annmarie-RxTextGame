//
//  Player.swift
//  Annmarie-RxTextGame
//
//  Created by Lucas Chan on 9/3/21.
//

import Foundation

enum Status {
    case Healthy
    case Injured
    case Dead
}

struct Player {
    var name: String
    var status: Status
    var chests: Int
    var position: Position
    
    init() {
        self.name = ""
        self.status = Status.Healthy
        self.chests = 0
        self.position = Position(x: 0, y: 0)
    }
    
    mutating func updatePlayer(name: String, status: Status, chests: Int, position: Position) {
        self.name = name
        self.chests = chests
        self.status = status
        self.position = position
    }
}
