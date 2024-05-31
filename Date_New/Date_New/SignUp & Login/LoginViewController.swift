//
//  LoginViewController.swift
//  Date_New
//
//  Created by 송재곤 on 5/29/24.
//

import UIKit
import SQLite

class LoginViewController: UIViewController {
    
    weak var delegate: LoginDelegate?
    
    // SQLite 데이터베이스 연결
    var db: Connection?
    
    let userIDTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "User ID"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 데이터베이스 파일 복사 및 연결
        setupDatabase()
        
        setupViews()
    }
    
    private func setupDatabase() {
        do {
            // 번들 내의 데이터베이스 파일 경로
            if let bundleDBPath = Bundle.main.path(forResource: "DateAppDataBase", ofType: "db") {
                // 앱의 문서 디렉토리 경로
                let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileURL = documentDirectory.appendingPathComponent("DateAppDataBase.db")
                
                // 데이터베이스 파일이 문서 디렉토리에 없다면 복사
                if !FileManager.default.fileExists(atPath: fileURL.path) {
                    do {
                        try FileManager.default.copyItem(atPath: bundleDBPath, toPath: fileURL.path)
                        print("Database file copied to documents directory")
                    } catch {
                        print("Error copying database file: \(error)")
                    }
                } else {
                    print("Database file already exists at path: \(fileURL.path)")
                }
                
                // 데이터베이스 연결
                db = try Connection(fileURL.path)
                print("Database connected at: \(fileURL.path)")
            } else {
                print("Database file not found in bundle")
            }
        } catch {
            print("Error setting up database: \(error)")
        }
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [userIDTextField, passwordTextField, loginButton, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    @objc private func loginButtonTapped() {
        guard let db = db else {
            print("Database connection not established")
            return
        }
        
        // 사용자가 입력한 ID와 Password 가져오기
        guard let userID = userIDTextField.text, let password = passwordTextField.text else {
            print("User ID or Password is empty")
            return
        }
        
        // 사용자 테이블 생성
        let users = Table("users")
        let userIDColumn = Expression<String>("user_id")
        let passwordColumn = Expression<String>("password")
        
        // 입력된 ID와 Password가 데이터베이스에 있는지 확인
        let user = users.filter(userIDColumn == userID && passwordColumn == password)
        do {
            if try db.scalar(user.count) > 0 {
                // 사용자가 존재하면 로그인 성공
                print("Login successful")
                UserDefaults.standard.set(true, forKey: "isLoggedIn") // 로그인 상태 저장
                delegate?.didLoginSuccessfully() // 로그인 성공 알림
                dismiss(animated: true, completion: nil) // 이전 화면으로 돌아가기
            } else {
                // 사용자가 존재하지 않으면 로그인 실패
                showAlert(message: "Invalid credentials")
            }
        } catch {
            print("Error checking for user: \(error)")
        }
    }
    
    @objc private func signUpButtonTapped() {
        let signUpViewController = SignUpViewController()
        let navigationController = UINavigationController(rootViewController: signUpViewController)
        navigationController.modalPresentationStyle = .overFullScreen // 전체 화면으로 표시되도록 설정
        present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
