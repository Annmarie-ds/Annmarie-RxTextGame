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
    
    let viewModel = GameViewModel()
    let gameOverVC = GameOverViewController()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        //label.text = "Status: \(Status.Healthy)"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        viewModel.setPlayerHealth
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                label.text = "Status: \(text)"
            })
            .disposed(by: disposeBag)
        
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.numberOfLines = 3
        label.textColor = UIColor.white
        
        viewModel.descriptionTextObservable
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
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

        button.rx.tap
            .map { Direction.Up }
            .bind(to: viewModel.buttonTapped)
            .disposed(by: disposeBag)
        
        viewModel.upButtonEnabled
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.upButtonEnabled
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { boolean in
                if boolean == true {
                    button.backgroundColor = UIColor.white
                } else {
                    button.backgroundColor = UIColor.gray
                }
            })
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
        
        button.rx.tap
            .map { Direction.Down }
            .bind(to: viewModel.buttonTapped)
            .disposed(by: disposeBag)
        
        viewModel.downButtonEnabled
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.downButtonEnabled
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { boolean in
                if boolean == true {
                    button.backgroundColor = UIColor.white
                } else {
                    button.backgroundColor = UIColor.gray
                }
            })
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
        
        button.rx.tap
            .map { Direction.Left }
            .bind(to: viewModel.buttonTapped)
            .disposed(by: disposeBag)
        
        viewModel.leftButtonEnabled
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.leftButtonEnabled
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { boolean in
                if boolean == true {
                    button.backgroundColor = UIColor.white
                } else {
                    button.backgroundColor = UIColor.gray
                }
            })
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
        
        button.rx.tap
            .map { Direction.Right }
            .bind(to: viewModel.buttonTapped)
            .disposed(by: disposeBag)
        
        viewModel.rightButtonEnabled
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.rightButtonEnabled
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { boolean in
                if boolean == true {
                    button.backgroundColor = UIColor.white
                } else {
                    button.backgroundColor = UIColor.gray
                }
            })
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
            .map { Direction.Action }
            .bind(to: viewModel.buttonTapped)
            .disposed(by: disposeBag)
        
        viewModel.actionButtonEnabled
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.actionButtonEnabled
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { boolean in
                if boolean == true {
                    button.backgroundColor = UIColor.white
                } else {
                    button.backgroundColor = UIColor.gray
                }
            })
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
        setupBindings()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    func setupBindings() {
        
        viewModel.gameOver
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { boolean in
                if boolean {
                    self.navigationController?.pushViewController(self.gameOverVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.playerUpdated
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { player in
                self.gameOverVC.playerChestsScore.text = "You found \(player.chests) chests!"
                
                if player.status == .Dead {
                    self.gameOverVC.resultsLabel.text = "GAME OVER! \nYou died!"
                } else {
                    self.gameOverVC.resultsLabel.text = "GAME OVER! \nCongratulations you won!"
                }
            })
        .disposed(by: disposeBag)
    }
}
