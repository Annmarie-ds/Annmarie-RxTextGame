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
    var player: Player = Player()

    //MARK: - actions
    var playerName: PublishSubject<String> = PublishSubject()
    var playerStatus: BehaviorRelay<Status> = BehaviorRelay<Status>(value: Status.Healthy)
    var playerChests: BehaviorRelay<Int> = BehaviorRelay<Int>(value: 0)
    var descriptionText: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    //MARK: - observables
    lazy var playerNameObservable: Observable<String> = {
        return playerName.asObservable()
    }()
    
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
    
    func validPosition() -> Bool {
        if (self.player.position.x >= 0 && self.player.position.x <= 3) && (self.player.position.y >= 0 && self.player.position.y <= 3){
            return true
        } else {
            return false
        }
    }
    
    func getChest(player: Player) {
        self.player.chests += 1
    }
    
    func hitTrap() {
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
            if validPosition() {
                self.player.updatePlayer(name: player.name, status: player.status, chests: 0, position: Position(x: player.position.x - 1, y: player.position.y))
            }
        case .Right:
            if validPosition() {
                self.player.updatePlayer(name: player.name, status: player.status, chests: 0, position: Position(x: player.position.x + 1, y: player.position.y))
            }
        case .Up:
            if validPosition() {
                self.player.updatePlayer(name: player.name, status: player.status, chests: 0, position: Position(x: player.position.x, y: player.position.y - 1))
            }
        case .Down:
            if validPosition() {
                self.player.updatePlayer(name: player.name, status: player.status, chests: 0, position: Position(x: player.position.x, y: player.position.y + 1))
            }
        }
    }
    
    func updateDescription(position: Position, vc: GameViewController) -> String {
        switch position {
        case (Position(x: 0, y: 0)):
            vc.upButton.isEnabled = false
            vc.leftButton.isEnabled = false
            vc.downButton.isEnabled = true
            vc.rightButton.isEnabled = true
            return "Your current position is x: 0, y: 0"
        case (Position(x: 1, y: 0)):
            vc.upButton.isEnabled = false
            vc.leftButton.isEnabled = true
            vc.downButton.isEnabled = true
            vc.rightButton.isEnabled = true
            return "Your current position is x: 1, y: 0"
        case Position(x: 2, y: 0):
            vc.upButton.isEnabled = false
            vc.leftButton.isEnabled = true
            vc.downButton.isEnabled = true
            vc.rightButton.isEnabled = true
            return "Your current position is x: 2, y: 0"
        case (Position(x: 3, y: 0)):
            vc.upButton.isEnabled = false
            vc.rightButton.isEnabled = false
            vc.leftButton.isEnabled = true
            vc.downButton.isEnabled = true
            return "Your current position is x: 3, y: 0"
        case (Position(x: 0, y: 1)):
            vc.leftButton.isEnabled = false
            vc.upButton.isEnabled = true
            vc.downButton.isEnabled = true
            vc.rightButton.isEnabled = true
            return "Your current position is x: 0, y: 1"
        case (Position(x: 1, y: 1)):
            vc.leftButton.isEnabled = true
            vc.upButton.isEnabled = true
            vc.downButton.isEnabled = true
            vc.rightButton.isEnabled = true
            return "Your current position is x: 1, y: 1"
        case (Position(x: 2, y: 1)):
            vc.leftButton.isEnabled = true
            vc.upButton.isEnabled = true
            vc.downButton.isEnabled = true
            vc.rightButton.isEnabled = true
            return "Your current position is x: 2, y: 1"
        case (Position(x: 3, y: 1)):
            vc.rightButton.isEnabled = false
            vc.leftButton.isEnabled = true
            vc.upButton.isEnabled = true
            vc.downButton.isEnabled = true
            return "Your current position is x: 3, y: 1"
        case (Position(x: 0, y: 2)):
            vc.leftButton.isEnabled = false
            vc.upButton.isEnabled = true
            vc.downButton.isEnabled = true
            vc.rightButton.isEnabled = true
            return "Your current position is x: 0, y: 2"
        case (Position(x: 1, y: 2)):
            vc.leftButton.isEnabled = true
            vc.upButton.isEnabled = true
            vc.downButton.isEnabled = true
            vc.rightButton.isEnabled = true
            return "Your current position is x: 1, y: 2"
        case (Position(x: 2, y: 2)):
            vc.leftButton.isEnabled = true
            vc.upButton.isEnabled = true
            vc.downButton.isEnabled = true
            vc.rightButton.isEnabled = true
            return "Your current position is x: 2, y: 2"
        case (Position(x: 3, y: 2)):
            vc.rightButton.isEnabled = false
            vc.leftButton.isEnabled = true
            vc.upButton.isEnabled = true
            vc.downButton.isEnabled = true
            return "Your current position is x: 3, y: 2"
        case (Position(x: 0, y: 3)):
            vc.downButton.isEnabled = false
            vc.leftButton.isEnabled = false
            vc.upButton.isEnabled = true
            vc.rightButton.isEnabled = true
            return "Your current position is x: 0, y: 3"
        case (Position(x: 1, y: 3)):
            vc.downButton.isEnabled = false
            vc.leftButton.isEnabled = true
            vc.upButton.isEnabled = true
            vc.rightButton.isEnabled = true
            return "Your current position is x: 1, y: 3"
        case (Position(x: 2, y: 3)):
            vc.downButton.isEnabled = false
            vc.leftButton.isEnabled = true
            vc.upButton.isEnabled = true
            vc.rightButton.isEnabled = true
            return "Your current position is x: 2, y: 3"
        case (Position(x: 3, y: 3)):
            vc.downButton.isEnabled = false
            vc.rightButton.isEnabled = false
            vc.leftButton.isEnabled = true
            vc.upButton.isEnabled = true
            return "You have reached the finish line!"
        default:
            break
        }
        return ""
    }

}
