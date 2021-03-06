//
//  ViewController.swift
//  Annmarie-RxTextGame
//
//  Created by Lucas Chan on 5/3/21.
//

import UIKit
import RxSwift
import RxCocoa

class StartViewController: UIViewController {
    let viewModel = ViewModel()
    let gameVC = GameViewController()
    let disposeBag = DisposeBag()
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Enter Name Below"
        label.textAlignment = .center
        label.font = label.font.withSize(30)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameTextField: UITextField = {
        let name = UITextField()
        name.placeholder = "Enter name here..."
        name.backgroundColor = UIColor.lightGray
        name.textColor = UIColor.white
        name.borderStyle = .roundedRect
        name.returnKeyType = .done
        name.font = name.font?.withSize(20)
        name.translatesAutoresizingMaskIntoConstraints = false
        
        name.rx.text
            .orEmpty
            .asObservable()
            .bind(to: viewModel.playerName)
            .disposed(by: disposeBag)
        
        return name
    }()

    lazy var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Start", for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.rx.tap
            .bind {
                print("button tapped")
                self.navigationController?.pushViewController(self.gameVC, animated: true)
            }
            .disposed(by: disposeBag)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [textLabel, nameTextField, startButton])
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        view.addSubview(stackView)
        setupLayout()
        setupBindings()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 4/5),
            textLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/8),
            startButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/5),
            startButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/5)
        ])
    }
    
    func setupBindings() {
        viewModel.playerNameObservable
            .subscribe(onNext: { (text) in
                print(text)
                self.nameTextField.text = text
            })
            .disposed(by: disposeBag)
    }
}

