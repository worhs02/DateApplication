import UIKit

class CafeViewController: UIViewController {
    
    weak var delegate: DateDelegate? // DateDelegate 프로토콜을 준수하는 객체를 위임할 delegate
    var selectedDate: Date? // 사용자가 선택한 날짜
    var name: String? // 카페의 이름을 저장할 변수
    
    let datePickerView = UIDatePicker() // 날짜 선택을 위한 UIDatePicker
    let doneButton = UIButton(type: .system) // 날짜 선택이 완료되었음을 나타내는 버튼
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 배경을 흰색으로 설정
        view.backgroundColor = .white
        
        // 장소 이름
        let nameLabel = UILabel() // 카페 이름을 표시할 레이블
        nameLabel.text = "투썸" // 카페의 이름 설정
        name = nameLabel.text // 이름 저장
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        // 카페 사진 이미지 뷰
        let cafeImageView = UIImageView(image: UIImage(named: "korea")) // 카페 사진을 표시할 이미지 뷰
        cafeImageView.contentMode = .scaleAspectFit // 이미지가 잘리지 않고 뷰에 맞게 비율을 유지하며 보임
        cafeImageView.clipsToBounds = true
        cafeImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cafeImageView)
                
        // 카페 설명 레이블
        let descriptionLabel = UILabel() // 카페 설명을 표시할 레이블
        descriptionLabel.text = "카페 설명을 여기에 작성하세요." // 카페 설명 설정
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
                
        
        // 버튼
        let button = UIButton(type: .system) // 날짜 선택을 위한 버튼
        button.setTitle("날짜 선택", for: .normal)
        button.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        // Auto Layout 설정
        NSLayoutConstraint.activate([
            
            // 이름 레이블
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                       
            // 카페 사진 이미지 뷰
            cafeImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            cafeImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cafeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cafeImageView.heightAnchor.constraint(equalToConstant: 200),
                       
            // 카페 설명 레이블
            descriptionLabel.topAnchor.constraint(equalTo: cafeImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // 버튼
            button.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 120),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Date Picker 설정
        datePickerView.datePickerMode = .date
        datePickerView.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        // Done 버튼 설정
        doneButton.setTitle("완료", for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func showDatePicker() {
        // Date Picker와 Done 버튼을 화면에 추가
        view.addSubview(datePickerView)
        view.addSubview(doneButton)
        
        // Date Picker Auto Layout 설정
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Done 버튼 스타일링
        doneButton.backgroundColor = .systemBlue
        doneButton.layer.cornerRadius = 15 // 둥근 모양으로 설정
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        // Done 버튼 Auto Layout 설정
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: datePickerView.bottomAnchor, constant: 20),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 120),
            doneButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    
    @objc func dateChanged() {
        selectedDate = datePickerView.date // 선택된 날짜 저장
    }
    
    @objc func doneButtonTapped() {
        // Done 버튼을 눌렀을 때 선택된 날짜를 처리
        if let selectedDate = selectedDate, let name = name {
            delegate?.didSelectDate(selectedDate, name) // 선택된 날짜와 이름 전달
            print("\(name)")
            navigationController?.popViewController(animated: true)
        } else {
            let today = Date() // 오늘 날짜를 가져옴
                    if let name = name {
                        delegate?.didSelectDate(today, name) // 오늘 날짜와 이름 전달
                        print("\(today)")
                        navigationController?.popViewController(animated: true)
                    } else {
                        print("Error: Name is nil") // name이 nil인 경우에 이 부분이 실행됩니다.
                    }
        }
        
        // Date Picker와 Done 버튼을 화면에서 제거
        datePickerView.removeFromSuperview()
        doneButton.removeFromSuperview()
    }
}
