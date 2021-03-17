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
    
    var player = GameViewModel().player
    var cells: [[Cell]] = GameViewModel().cells
    
    lazy var cellsSubject: BehaviorRelay<[Cell]> = BehaviorRelay<[Cell]>(value: cells.reduce([], +))
    lazy var playAgain: PublishSubject<Void> = PublishSubject()
    
    // results
    lazy var results: Observable<String> = {
        Observable.of(player)
            .map { _ in
                if self.player.status == .Dead {
                    return "GAME OVER! \nYou died!"
                } else {
                    return "GAME OVER! \nCongratulations you won!"
                }
            }
    }()
    
    // chestScore
    lazy var chestScore: Observable<String> = {
        Observable.of(player)
            .map { _ in
                return "You found \(self.player.chests) chests!"
            }
    }()
    
    
    // totalChests
    lazy var totalChests: Observable<String> = {
        cellsSubject
            .map { cell in
                var count = 0
                for item in cell {
                    if item.type == .chest {
                        count += 1
                    }
                }
                return "There are \(count) chests in total."
            }
    }()
    
    lazy var playAgainTapped: Observable<Void> = {
        playAgain
            .map { _ in
                //reset player
                self.player = Player()
                return
            }
    }()
}
