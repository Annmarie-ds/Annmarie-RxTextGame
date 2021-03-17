//
//  GameOverViewController.swift
//  Annmarie-RxTextGame
//
//  Created by Lucas Chan on 16/3/21.
//

import UIKit
import RxSwift
import RxCocoa

class GameOverViewController: UIViewController {

    let disposeBag = DisposeBag()
    let viewModel = GameOverViewModel()
    
    lazy var resultsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.green
        label.textAlignment = .center
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        viewModel.results
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {(text) in
                label.text = text
            })
            .disposed(by: disposeBag)
        
        return label
    }()
    
    lazy var playerChestsScore: UILabel = {
        let label = UILabel()
        label.text = "Score"
        label.numberOfLines = 3
        label.textAlignment = .center
        label.textColor = UIColor.green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var totalChests: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blue
        label.textAlignment = .center
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        viewModel.totalChests
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {(text) in
                label.text = text
            })
            .disposed(by: disposeBag)
        return label
    }()
    
    lazy var container: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [resultsLabel, playerChestsScore, totalChests])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .equalCentering
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(container)
        view.backgroundColor = UIColor.white
        setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }

}