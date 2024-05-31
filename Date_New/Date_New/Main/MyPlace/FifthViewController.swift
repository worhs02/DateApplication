//
//  FifthViewController.swift
//  Date_New
//
//  Created by 이슬기 on 4/27/24.
//

import UIKit

class FifthViewController: UIViewController, LoginDelegate  {
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "You are not logged in."
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        if !isLoggedIn() {
            setupViews()
        }
    }
    
    private func setupViews() {
        view.addSubview(messageLabel)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loginButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    @objc private func loginButtonTapped() {
        let loginViewController = LoginViewController()
        loginViewController.delegate = self // delegate 설정 추가
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.modalPresentationStyle = .overFullScreen // 전체 화면으로 표시되도록 설정
        present(navigationController, animated: true, completion: nil)
    }

    
    // MARK: - LoginDelegate
    
    func didLoginSuccessfully() {
        // 로그인 성공 시, 로그인 버튼과 메시지를 제거
        print("d")
        messageLabel.removeFromSuperview()
        loginButton.removeFromSuperview()
    }
}
