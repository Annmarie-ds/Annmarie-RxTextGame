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

class ViewModel {
    
    let disposeBag: DisposeBag = DisposeBag()
    var player: Player = StartViewModel().player

    //MARK: - actions

    var playerStatus: BehaviorRelay<Status> = BehaviorRelay<Status>(value: Status.Healthy)
    var playerChests: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    var descriptionText: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    //MARK: - observables
    
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
    
    func updateStatus() {
        switch self.player.status {
        case .Healthy:
            self.player.status = Status.Injured
        case .Injured:
            self.player.status = Status.Dead
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
