//
//  GameOverViewModel.swift
//  Annmarie-RxTextGame
//
//  Created by Lucas Chan on 17/3/21.
//

import Foundation
import RxSwift
import RxCocoa

class GameOverViewModel {
    
    var player: BehaviorRelay<Player> = BehaviorRelay<Player>(value: GameViewModel().player)
    
    var cells: BehaviorRelay<[[Cell]]> = BehaviorRelay<[[Cell]]>(value: GameViewModel().cells)

    // play again
    
    // results
    lazy var results: Observable<String> = {
        player
            .map { player in
                if player.status == Status.Healthy || player.status == Status.Injured {
                    return "GAME OVER! \nCongratulations you won!"
                } else {
                    return "GAME OVER! \nYou died!"
                }
            }
    }()
    
    // chestScore
    lazy var chestScore: Observable<String> = {
        player
            .map { player in
                return "You found \(player.chests) chests!"
            }
    }()
    
    // totalChests
    lazy var totalChests: Observable<String> = {
        cells
            .map { cell in
                print(cell.first as Any)
                return "Hello"
            }
    }()
    
    
    
}
