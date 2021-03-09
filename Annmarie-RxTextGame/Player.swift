//
//  Player.swift
//  Annmarie-RxTextGame
//
//  Created by Lucas Chan on 9/3/21.
//

import Foundation

enum status {
    case Healthy
    case Injured
    case Dead
}

struct Player {
    var name: String
    var status: status
    var chests: Int
    var position: Position
    
    init(name: String, status: status, chests: Int, position: Position) {
        self.name = name
        self.status = status
        self.chests = chests
        self.position = position
    }
}
