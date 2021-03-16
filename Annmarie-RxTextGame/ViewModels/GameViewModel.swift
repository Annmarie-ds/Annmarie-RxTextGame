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
    
    let disposeBag: DisposeBag = DisposeBag()
    var player: Player = StartViewModel().player
    
    private var cells: Array<[Cell]> = [
        // Top Row (column: x, row: y)
        [Cell(position: Position(x: 0, y: 0), type: cellType.start),
        Cell(position: Position(x: 1, y: 0), type: cellType.path),
        Cell(position: Position(x: 2, y: 0), type: cellType.path),
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
    
    //MARK: - observables
    var descriptionText: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    lazy var latestPosition: BehaviorRelay<Position> = BehaviorRelay<Position>(value: Position(x: 0, y: 0))
    
    lazy var descriptionTextObservable: Observable<String> = {
//        Observable.of(self.player)
//            .map { player in
//                print("value: \(player)")
//                return "Your current position is \(player.position.x), \(player.position.y)"
//            }
        latestPosition
            .map { position in Position(x: position.x, y: position.y)}
            .map { value in
                print(value)
                return "\(value)"
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
        setNewPosition
            .map { pos in
                if self.cells[pos.x][pos.y].type == .chest {
                    self.player.updatePlayer(name: self.player.name, status: self.player.status, chests: self.player.chests + 1, position: self.player.position)
                }
            }
    }()
    
    lazy var setPlayerHealth: Observable<Status> = {
        setNewPosition
            .map { pos in
                if self.cells[pos.x][pos.y].type == .trap {
                    self.updateStatus(player: self.player)
                }
                return self.player.status
            }
    }()
    
    lazy var setNewPosition: Observable<Position> = {
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
        .do(onNext: { pos in
            self.latestPosition.accept(pos)
        })
    }()
    
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
            // game over
        default:
            break
        }
    }
    
//    func move(direction: Direction) {
//        switch direction {
//        case .Left:
//            if validPosition(position: player.position) {
//                self.player.updatePlayer(name: player.name, status: player.status, chests: 0, position: Position(x: player.position.x - 1, y: player.position.y))
//            }
//        case .Right:
//            if validPosition(position: player.position) {
//                self.player.updatePlayer(name: player.name, status: player.status, chests: 0, position: Position(x: player.position.x + 1, y: player.position.y))
//            }
//        case .Up:
//            if validPosition(position: player.position) {
//                self.player.updatePlayer(name: player.name, status: player.status, chests: 0, position: Position(x: player.position.x, y: player.position.y - 1))
//            }
//        case .Down:
//            if validPosition(position: player.position) {
//                self.player.updatePlayer(name: player.name, status: player.status, chests: 0, position: Position(x: player.position.x, y: player.position.y + 1))
//            }
//        case .Action:
//            <#code#>
//        }
//    }

}