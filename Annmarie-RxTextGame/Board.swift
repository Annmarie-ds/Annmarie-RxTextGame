//
//  Board.swift
//  Annmarie-RxTextGame
//
//  Created by Lucas Chan on 9/3/21.
//

import Foundation

let boardCellCount = 16

struct Position {
    var x: Int
    var y: Int
}

struct Cell {
    var position: Position
    var active: Bool
    var type: String
    
    init(position: Position, active: Bool, type: String) {
        self.position = position
        self.active = active
        self.type = type
    }
}
