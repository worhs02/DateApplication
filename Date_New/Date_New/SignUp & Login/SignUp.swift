import UIKit
import SQLite

class SignUpViewController: UIViewController {
    
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
        
        // 뒤로 가기 버튼 추가
        setupBackButton()
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
        let stackView = UIStackView(arrangedSubviews: [userIDTextField, passwordTextField, signUpButton])
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
    
    private func setupBackButton() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    // MARK: - Actions
    
    @objc private func signUpButtonTapped() {
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
        
        // 중복 사용자 체크
        let duplicateUsers = users.filter(userIDColumn == userID)
        do {
            if try db.scalar(duplicateUsers.count) > 0 {
                // 중복된 사용자가 있을 경우
                print("User already exists")
                // Alert 표시
                showAlert(message: "User already exists")
                return
            }
        } catch {
            print("Error checking for duplicate users: \(error)")
            return
        }
        
        // 테이블에 사용자 추가
        do {
            try db.run(users.insert(userIDColumn <- userID, passwordColumn <- password))
            print("User added to database")
            let loginViewController = LoginViewController()
            let navigationController = UINavigationController(rootViewController: loginViewController)
            navigationController.modalPresentationStyle = .overFullScreen // 전체 화면으로 표시되도록 설정
            present(navigationController, animated: true, completion: nil)
        } catch {
            print("Error adding user: \(error)")
        }
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
