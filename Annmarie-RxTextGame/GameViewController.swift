//
//  GameViewController.swift
//  Annmarie-RxTextGame
//
//  Created by Lucas Chan on 9/3/21.
//

import UIKit
import RxSwift
import RxCocoa

class GameViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private var cells: Array<Cell> = []
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "PlayerName: "
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Status: "
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var discriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.white
        return label
    }()
    
    // TODO: Grid
    
    lazy var upButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("↑", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .heavy)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.rx.tap
            .bind {
                print("up button tapped")
            }
            .disposed(by: disposeBag)
        return button
    }()
    
    lazy var downButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("↓", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .heavy)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.rx.tap
            .bind {
                print("down button tapped")
            }
            .disposed(by: disposeBag)
        return button
    }()
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("←", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .heavy)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.rx.tap
            .bind {
                print("left button tapped")
            }
            .disposed(by: disposeBag)
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("→", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .heavy)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.rx.tap
            .bind {
                print("right button tapped")
            }
            .disposed(by: disposeBag)
        return button
    }()
    
    lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [leftButton, upButton, rightButton, downButton])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var labelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, statusLabel])
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        view.addSubview(labelStack)
        view.addSubview(buttonStack)
        
        setupLayout()
        
        self.cells = [
            // Top Row (row = y, column = x)
            Cell(position: Position(x: 0, y: 0), active: false, type: cellType.start),
            Cell(position: Position(x: 1, y: 0), active: false, type: cellType.path),
            Cell(position: Position(x: 2, y: 0), active: false, type: cellType.path),
            Cell(position: Position(x: 3, y: 0), active: false, type: cellType.path),
            
            // Second Row
            Cell(position: Position(x: 0, y: 1), active: false, type: cellType.chest),
            Cell(position: Position(x: 1, y: 1), active: false, type: cellType.trap),
            Cell(position: Position(x: 2, y: 1), active: false, type: cellType.path),
            Cell(position: Position(x: 3, y: 1), active: false, type: cellType.chest),
            
            // Third Row
            Cell(position: Position(x: 0, y: 2), active: false, type: cellType.path),
            Cell(position: Position(x: 1, y: 2), active: false, type: cellType.chest),
            Cell(position: Position(x: 2, y: 2), active: false, type: cellType.trap),
            Cell(position: Position(x: 3, y: 2), active: false, type: cellType.path),
            
            // Last Row
            Cell(position: Position(x: 0, y: 3), active: false, type: cellType.trap),
            Cell(position: Position(x: 1, y: 3), active: false, type: cellType.path),
            Cell(position: Position(x: 2, y: 3), active: false, type: cellType.chest),
            Cell(position: Position(x: 3, y: 3), active: false, type: cellType.finish)
        ]
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            labelStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            labelStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            labelStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            buttonStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width/4),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: view.frame.width/4)
        ])
    }

}
