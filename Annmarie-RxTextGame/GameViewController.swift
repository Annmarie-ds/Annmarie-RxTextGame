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
    
    let viewModel = ViewModel()
    
    let numberOfRows: ClosedRange = 0...3
    let numberOfColumns: ClosedRange = 0...3
    var startCoordinates = Position(x: 0,y: 0)
    var finishCoordinates = Position(x: 3,y: 3)
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Player Name: \(viewModel.playerName)"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Status: \(Status.Healthy)"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.numberOfLines = 3
        label.textColor = UIColor.white

//        label.rx.text
//            .orEmpty
//            .bind(to: viewModel.descriptionText)
//            .disposed(by: disposeBag)
        
        return label
    }()
    
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
                if self.viewModel.player.position.y > 0 {
                    if self.viewModel.validPosition() {
                        self.viewModel.move(direction: Direction.Up)
                    }
                } else {
                    button.isEnabled = false
                    button.backgroundColor = UIColor.lightGray
                }
                print(self.viewModel.player)
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
                if self.viewModel.player.position.y < 3 {
                    if self.viewModel.validPosition() {
                        self.viewModel.move(direction: Direction.Down)
                    }
                } else {
                    button.isEnabled = false
                    button.backgroundColor = UIColor.lightGray
                }

                print(self.viewModel.player)
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
                if self.viewModel.player.position.x > 0 {
                    if self.viewModel.validPosition() {
                        self.viewModel.move(direction: Direction.Left)
                    }
                } else {
                    button.isEnabled = false
                    button.backgroundColor = UIColor.lightGray
                }

                print(self.viewModel.player)
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
                if self.viewModel.player.position.x < 3 {
                    if self.viewModel.validPosition() {
                        self.viewModel.move(direction: Direction.Right)
                    }
                } else {
                    button.isEnabled = false
                    button.backgroundColor = UIColor.lightGray
                }
                
                print(self.viewModel.player)
            }
            .disposed(by: disposeBag)
        return button
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("Go", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .heavy)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
        // bind to label text - print player position
    }()
    
    lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [leftButton, upButton, rightButton, downButton, actionButton])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 10
        stack.alignment = .center
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
    
    lazy var container: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [labelStack, descriptionLabel, buttonStack])
        stack.axis = .vertical
        stack.spacing = 50
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        view.addSubview(container)
        
        setupLayout()
        
        self.cells = [
            // Top Row (column: x, row: y)
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
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
}
