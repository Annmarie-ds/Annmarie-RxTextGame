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
    var chests: Int = 0
    
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
    let actionButtonTapped: PublishSubject<Direction> = PublishSubject()
    
    //MARK: - observables
    lazy var latestPosition: BehaviorRelay<Position> = BehaviorRelay<Position>(value: Position(x: 0, y: 0))
    
    lazy var playerUpdated: BehaviorRelay<Player> = BehaviorRelay<Player>(value: Player())
    
    lazy var descriptionTextObservable: Observable<String> = {
        latestPosition
            .map { position in Position(x: position.x, y: position.y)}
            .map { [weak self] value in
                if self?.cells[value.x][value.y].type == .chest {
                    return "Your current position is \(value.x), \(value.y), \n you have found a chest! Click action!"
                } else if self?.cells[value.x][value.y].type == .trap {
                    return "Your current position is \(value.x), \(value.y), \n you fell in a trap!"
                } else {
                    return "Your current position is \(value.x), \(value.y)"
                }
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
    
    lazy var actionButtonEnabled: Observable<Bool> = {
        latestPosition
            .map { position in Position(x: position.x, y: position.y)}
            .map { [weak self] newPosition -> Bool in
                if self?.cells[newPosition.x][newPosition.y].type == .chest {
                    return true
                } else {
                    return false
                }
            }
    }()
    
    lazy var updateChestCount: Observable<Int> = {
        latestPosition
            .map { pos in
                if self.cells[pos.x][pos.y].type == .chest {
                    self.chests += 1
                }
                return self.chests
            }
    }()
    
    lazy var playerDetails: Observable<Player> = {
        playerUpdated
            .map { player in
                return player
            }
    }()
    
    lazy var setPlayerHealth: Observable<Status> = {
        latestPosition
            .map { pos in
                if self.cells[pos.x][pos.y].type == .trap {
                    self.updateStatus(player: self.player)
                }
                return self.player.status 
            }
    }()
    
    lazy var updatePosition: Observable<Position> = {
       buttonTapped
        .withLatestFrom(latestPosition) { ($0, $1) }
        .map { direction, position -> Position in
            switch direction {
            case .Up:
                let upPos = Position(x: position.x, y: position.y - 1)
                self.player.updatePlayer(name: self.player.name, status: self.player.status, chests: self.player.chests, position: upPos)
                return upPos
            case .Left:
                let leftPos = Position(x: position.x - 1, y: position.y)
                self.player.updatePlayer(name: self.player.name, status: self.player.status, chests: self.player.chests, position: leftPos)
                return leftPos
            case .Right:
                let rightPos = Position(x: position.x + 1, y: position.y)
                self.player.updatePlayer(name: self.player.name, status: self.player.status, chests: self.player.chests, position: rightPos)
                return rightPos
            case .Down:
                let downPos = Position(x: position.x, y: position.y + 1)
                self.player.updatePlayer(name: self.player.name, status: self.player.status, chests: self.player.chests, position: downPos)
                return downPos
            case .Action:
                self.player.updatePlayer(name: self.player.name, status: self.player.status, chests: self.player.chests + 1, position: position)
                return Position(x: position.x, y: position.y)
            }
        }
        .do(onNext: { [weak self] pos in
            if self?.validPosition(position: pos) == true {
                self?.latestPosition.accept(pos)
                self?.playerUpdated.accept(self?.player ?? Player())
            }
        })
    }()
    
    lazy var gameOver: Observable<Bool> = {
        updatePosition
            .filter { pos in Position(x: pos.x, y: pos.y) == Position(x: 3, y: 3) || self.player.status == Status.Dead }
            .map { _ in
                return true
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
