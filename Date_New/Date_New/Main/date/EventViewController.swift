import UIKit

protocol EventViewControllerDelegate: AnyObject {
    func didSaveEvent(_ eventText: String)
}

class EventViewController: UIViewController {
    
    weak var delegate: EventViewControllerDelegate?
    var selectedDateComponents: DateComponents?
    
    let eventTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter event details"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(eventTextField)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            eventTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            eventTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            eventTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            saveButton.topAnchor.constraint(equalTo: eventTextField.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func saveButtonTapped() {
        guard let eventText = eventTextField.text, !eventText.isEmpty else {
            return
        }
        
        delegate?.didSaveEvent(eventText)
        dismiss(animated: true)
    }
}
