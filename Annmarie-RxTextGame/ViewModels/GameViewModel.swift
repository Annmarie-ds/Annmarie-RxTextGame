//
//  ViewModel.swift
//  Annmarie-RxTextGame
//
//  Created by Lucas Chan on 5/3/21.
//

import Foundation
import RxSwift
import RxCocoa

enum Direction {
    case Left
    case Right
    case Up
    case Down
    case Action
}

class GameViewModel {

    var player: Player = StartViewModel().player
    
    var cells: [[Cell]] = [
        // Top Row (column: x, row: y)
        [Cell(position: Position(x: 0, y: 0), type: cellType.start),
        Cell(position: Position(x: 1, y: 0), type: cellType.path),
        Cell(position: Position(x: 2, y: 0), type: cellType.chest),
        Cell(position: Position(x: 3, y: 0), type: cellType.path)],
        
        // Second Row
        [Cell(position: Position(x: 0, y: 1), type: cellType.chest),
        Cell(position: Position(x: 1, y: 1), type: cellType.trap),
        Cell(position: Position(x: 2, y: 1), type: cellType.path),
        Cell(position: Position(x: 3, y: 1), type: cellType.chest)],
        
        // Third Row
        [Cell(position: Position(x: 0, y: 2), type: cellType.path),
        Cell(position: Position(x: 1, y: 2), type: cellType.chest),
        Cell(position: Position(x: 2, y: 2), type: cellType.trap),
        Cell(position: Position(x: 3, y: 2), type: cellType.path)],
        
        // Last Row
        [Cell(position: Position(x: 0, y: 3), type: cellType.trap),
        Cell(position: Position(x: 1, y: 3), type: cellType.path),
        Cell(position: Position(x: 2, y: 3), type: cellType.chest),
        Cell(position: Position(x: 3, y: 3), type: cellType.finish)]
    ]
    
    //MARK: - subjects
    let buttonTapped: PublishSubject<Direction> = PublishSubject()
    
    lazy var cellsSubject: BehaviorRelay<[Cell]> = BehaviorRelay<[Cell]>(value: cells.reduce([], +))

    lazy var playAgain: PublishSubject<Void> = PublishSubject()
    
    //MARK: - observables
    lazy var latestPosition: BehaviorRelay<Position> = BehaviorRelay<Position>(value: Position(x: 0, y: 0))
    
    lazy var descriptionTextObservable: Observable<String> = {
        latestPosition
            .map { position in Position(x: position.x, y: position.y)}
            .map { [weak self] value in
                return "Your current position is \(value)"
            }
    }()
    
    lazy var upButtonEnabled: Observable<Bool> = {
        latestPosition
            .map { position in Position(x: position.x, y: position.y - 1)}
            .map { [weak self] newPosition -> Bool in
                self?.validPosition(position: newPosition) ?? false
            }
    }()
    
    lazy var downButtonEnabled: Observable<Bool> = {
        latestPosition
            .map { position in Position(x: position.x, y: position.y + 1)}
            .map { [weak self] newPosition -> Bool in
                self?.validPosition(position: newPosition) ?? false
            }
    }()
    
    lazy var leftButtonEnabled: Observable<Bool> = {
        latestPosition
            .map { position in Position(x: position.x - 1, y: position.y)}
            .map { [weak self] newPosition -> Bool in
                self?.validPosition(position: newPosition) ?? false
            }
    }()
    
    lazy var rightButtonEnabled: Observable<Bool> = {
        latestPosition
            .map { position in Position(x: position.x + 1, y: position.y)}
            .map { [weak self] newPosition -> Bool in
                self?.validPosition(position: newPosition) ?? false
            }
    }()
    
    lazy var updateChest: Observable<Void> = {
        latestPosition
            .map { pos in
                if self.cells[pos.x][pos.y].type == .chest {
                    self.player.updatePlayer(name: self.player.name, status: self.player.status, chests: self.player.chests + 1, position: self.player.position)
                }
            }
    }()
    
    lazy var setPlayerHealth: Observable<Status> = {
        latestPosition
            .map { [weak self] pos in
                if self?.cells[pos.x][pos.y].type == .trap {
                    self?.updateStatus(player: self?.player ?? Player())
                }
                return self?.player.status ?? Status.Healthy
            }
    }()
    
    lazy var updatePosition: Observable<Position> = {
       buttonTapped
        .withLatestFrom(latestPosition) { ($0, $1) }
        .map { button, position -> Position in
            switch button {
            case .Up:
                return Position(x: position.x, y: position.y - 1)
            case .Left:
                return Position(x: position.x - 1, y: position.y)
            case .Right:
                return Position(x: position.x + 1, y: position.y)
            case .Down:
                return Position(x: position.x, y: position.y + 1)
            case .Action:
                return Position(x: position.x, y: position.y)
            }
        }
        .do(onNext: { [weak self] pos in
            if self?.validPosition(position: pos) == true {
                self?.latestPosition.accept(pos)
            }
        })
    }()
    
    lazy var gameOver: Observable<Bool> = {
        updatePosition
            .filter { position in Position(x: position.x, y: position.y) == Position(x: 3, y: 3) || self.player.status == Status.Dead }
            .map { _ in
                switch self.player.status {
                case .Dead:
                    return true
                default:
                    return false
                }
            }
    }()
    
    //MARK: - game over
    
    // results
    lazy var results: Observable<String> = {
        latestPosition
            .map { _ in
                if self.player.status == .Healthy || self.player.status == .Injured {
                    return "GAME OVER! \nCongratulations you won!"
                } else {
                    return "GAME OVER! \nYou died!"
                }
            }
    }()
    
    // chestScore
    lazy var chestScore: Observable<String> = {
        latestPosition
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
    
    //MARK: - functions
    
    func validPosition(position: Position) -> Bool {
        if position.x >= 0 && position.x <= 3 && position.y >= 0 && position.y <= 3 {
            return true
        } else {
            return false
        }
    }
    
    func updateStatus(player: Player) {
        switch player.status {
        case .Healthy:
            self.player.updatePlayer(name: player.name, status: Status.Injured, chests: player.chests, position: player.position)
        case .Injured:
            self.player.updatePlayer(name: player.name, status: Status.Dead, chests: player.chests, position: player.position)
        default:
            break
        }
    }

}
