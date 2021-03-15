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
        
        viewModel.descriptionTextObservable
            .subscribe(onNext: {(text) in
                label.text = text
            })
            .disposed(by: disposeBag)
        
        return label
    }()
    
    lazy var upButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("↑", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .heavy)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        if viewModel.player.position.y == 0 {
            button.backgroundColor = UIColor.gray
        } else {
            button.backgroundColor = UIColor.white
        }

        button.rx.tap
            .bind {
                if self.viewModel.player.position.y > 0 {
                    self.viewModel.move(direction: Direction.Up)
                }
                print(self.viewModel.player)
            }
            .disposed(by: disposeBag)
        
        return button
    }()
    
    lazy var downButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("↓", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .heavy)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if viewModel.player.position.y == 3 {
            button.backgroundColor = UIColor.gray
        } else {
            button.backgroundColor = UIColor.white
        }
        
        button.rx.tap
            .bind {
                if self.viewModel.player.position.y < 3 {
                    self.viewModel.move(direction: Direction.Down)
                }
                print(self.viewModel.player)
            }
            .disposed(by: disposeBag)
        return button
    }()
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("←", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .heavy)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false

        if viewModel.player.position.x == 0 {
            button.backgroundColor = UIColor.gray
        } else {
            button.backgroundColor = UIColor.white
        }
        
        button.rx.tap
            .bind {
                if self.viewModel.player.position.x > 0 {
                    self.viewModel.move(direction: Direction.Left)
                    self.viewModel.getChest(player: self.viewModel.player)
                }
                print(self.viewModel.player)
            }
            .disposed(by: disposeBag)
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("→", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .heavy)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if viewModel.player.position.x == 3 {
            button.backgroundColor = UIColor.gray
        } else {
            button.backgroundColor = UIColor.white
        }
        
        button.rx.tap
            .bind {
                if self.viewModel.player.position.x < 3 {
                    self.viewModel.move(direction: Direction.Right)
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
        button.setTitle("Action", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .heavy)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.rx.tap
            .bind {
                self.descriptionLabel.text = "Your current position is \(self.viewModel.player.position.x), \(self.viewModel.player.position.y)"
            }
            .disposed(by: disposeBag)
        
        return button
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
            Cell(position: Position(x: 0, y: 0), type: cellType.start),
            Cell(position: Position(x: 1, y: 0), type: cellType.path),
            Cell(position: Position(x: 2, y: 0), type: cellType.path),
            Cell(position: Position(x: 3, y: 0), type: cellType.path),
            
            // Second Row
            Cell(position: Position(x: 0, y: 1), type: cellType.chest),
            Cell(position: Position(x: 1, y: 1), type: cellType.trap),
            Cell(position: Position(x: 2, y: 1), type: cellType.path),
            Cell(position: Position(x: 3, y: 1), type: cellType.chest),
            
            // Third Row
            Cell(position: Position(x: 0, y: 2), type: cellType.path),
            Cell(position: Position(x: 1, y: 2), type: cellType.chest),
            Cell(position: Position(x: 2, y: 2), type: cellType.trap),
            Cell(position: Position(x: 3, y: 2), type: cellType.path),
            
            // Last Row
            Cell(position: Position(x: 0, y: 3), type: cellType.trap),
            Cell(position: Position(x: 1, y: 3), type: cellType.path),
            Cell(position: Position(x: 2, y: 3), type: cellType.chest),
            Cell(position: Position(x: 3, y: 3), type: cellType.finish)
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
