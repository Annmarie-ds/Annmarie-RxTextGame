//
//  Board.swift
//  Annmarie-RxTextGame
//
//  Created by Lucas Chan on 9/3/21.
//

import Foundation
import UIKit


let boardCellCount = 16

enum cellType {
    case path
    case chest
    case trap
    case start
    case finish
}


struct Position: Equatable {
    var x: Int
    var y: Int
}

struct Cell {
    var position: Position
    var active: Bool
    var type: cellType
    
    init(position: Position, active: Bool, type: cellType) {
        self.position = position
        self.active = active
        self.type = type
    }

}
