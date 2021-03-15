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
}

class GameViewModel {
    
    let disposeBag: DisposeBag = DisposeBag()
    var player: Player = StartViewModel().player
    
    //MARK: - subjects
    let selectedButton: PublishSubject<Direction> = PublishSubject()

    //MARK: - actions

    var playerStatus: BehaviorRelay<Status> = BehaviorRelay<Status>(value: Status.Healthy)
    var playerChests: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    var descriptionText: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    //MARK: - observables
    
    lazy var latestPosition: BehaviorRelay<Position> = BehaviorRelay<Position>(value: Position(x: 0, y: 0))
    
    lazy var playerStatusObservable: Observable<Status> = {
        return playerStatus.asObservable()
    }()
    
    lazy var playerChestsObservable: Observable<Int> = {
        return playerChests.asObservable()
    }()
    
    lazy var descriptionTextObservable: Observable<String> = {
        Observable.of(self.player)
            .map { _ in
                return "Your current position is \(self.player.position.x), \(self.player.position.y)"
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
    
    func validPosition(position: Position) -> Bool {
        if position.x >= 0 && position.x <= 3 && position.y >= 0 && position.y <= 3 {
            return true
        } else {
            return false
        }
    }
    
    func getChest(player: Player) {        
        switch player.position {
        case Position(x: 0, y: 1):
            self.player.updatePlayer(name: player.name, status: player.status, chests: player.chests + 1, position: player.position)
        case Position(x: 3, y: 1):
            self.player.updatePlayer(name: player.name, status: player.status, chests: player.chests + 1, position: player.position)
        case Position(x: 1, y: 2):
            self.player.updatePlayer(name: player.name, status: player.status, chests: player.chests + 1, position: player.position)
        case Position(x: 2, y: 2):
            self.player.updatePlayer(name: player.name, status: player.status, chests: player.chests + 1, position: player.position)
        default:
            break
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
    
    func move(direction: Direction) {
        switch direction {
        case .Left:
            if validPosition(position: player.position) {
                self.player.updatePlayer(name: player.name, status: player.status, chests: 0, position: Position(x: player.position.x - 1, y: player.position.y))
            }
        case .Right:
            if validPosition(position: player.position) {
                self.player.updatePlayer(name: player.name, status: player.status, chests: 0, position: Position(x: player.position.x + 1, y: player.position.y))
            }
        case .Up:
            if validPosition(position: player.position) {
                self.player.updatePlayer(name: player.name, status: player.status, chests: 0, position: Position(x: player.position.x, y: player.position.y - 1))
            }
        case .Down:
            if validPosition(position: player.position) {
                self.player.updatePlayer(name: player.name, status: player.status, chests: 0, position: Position(x: player.position.x, y: player.position.y + 1))
            }
        }
    }

}
