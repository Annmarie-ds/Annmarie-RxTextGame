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
    
    lazy var resultsLabel: UILabel = {
        let label = UILabel()
        label.text = "Results"
        label.textColor = UIColor.green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var playerChestsScore: UILabel = {
        let label = UILabel()
        label.text = "Score"
        label.textColor = UIColor.green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var totalChests: UILabel = {
        let label = UILabel()
        label.text = "Total chests"
        label.textColor = UIColor.blue
        label.translatesAutoresizingMaskIntoConstraints = false
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
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }

}
