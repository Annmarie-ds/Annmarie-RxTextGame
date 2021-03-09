//
//  ViewModel.swift
//  Annmarie-RxTextGame
//
//  Created by Lucas Chan on 5/3/21.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel {
    
    let disposeBag: DisposeBag = DisposeBag()
    
    //MARK: - actions
    let playerName: PublishSubject<String> = PublishSubject()
    
    //MARK: - observables
    lazy var playerNameObservable: Observable<String> = {
        return playerName.asObservable()
    }()
}
