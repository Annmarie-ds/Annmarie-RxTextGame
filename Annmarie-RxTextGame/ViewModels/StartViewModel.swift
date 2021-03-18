//
//  StartViewModel.swift
//  Annmarie-RxTextGame
//
//  Created by Lucas Chan on 15/3/21.
//

import Foundation
import RxSwift
import RxCocoa

class StartViewModel {
    
    var player: Player = Player()

    var playerName: BehaviorRelay<String> = BehaviorRelay<String>(value: "")

    lazy var playerNameObservable: Observable<String> = {
        return playerName.asObservable()
    }()
}

