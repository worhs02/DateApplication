import UIKit

protocol EventViewControllerDelegate: AnyObject {
    func didSaveEvent(_ eventText: String)
}

class EventViewController: UIViewController {

    weak var delegate: EventViewControllerDelegate?
    var selectedDateComponents: DateComponents?
    var events: [String] = [] // events 배열을 속성으로 추가

    let eventTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter event details"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Event", for: .normal)
        button.addTarget(self, action: #selector(saveEvent), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let eventLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 // 여러 줄로 나열되도록 설정
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func updateEventLabel() {
        let combinedEvents = events.joined(separator: "\n") // 모든 이벤트를 하나의 문자열로 결합
        eventLabel.text = combinedEvents // 결합된 이벤트를 UILabel에 표시
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground

        self.view.addSubview(eventTextField)
        self.view.addSubview(saveButton)
        self.view.addSubview(eventLabel)

        NSLayoutConstraint.activate([
            eventTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            eventTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            eventTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),

            saveButton.topAnchor.constraint(equalTo: eventTextField.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),

            eventLabel.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            eventLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            eventLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
    }

    @objc func saveEvent() {
        guard let eventText = eventTextField.text else {
            return
        }
        delegate?.didSaveEvent(eventText)
        events.append(eventText) // 기존 이벤트를 초기화하지 않고 새 이벤트를 추가
        updateEventLabel() // 이벤트 텍스트 업데이트
    }
}
