import UIKit

class ViewController: UIViewController {
    
    // 탭바 생성
    let tabBar = UITabBar()
    
    // 키워드 레이블을 저장할 배열
    var keywordLabels: [UILabel] = []
    
    // + 버튼
    let plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        button.isHidden = true // 초기에는 숨겨진 상태
        return button
    }()
    
    // - 버튼
    let minusButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.isHidden = true // 초기에는 숨김 상태
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 탭바 생성
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tabBar)
        
        // 탭바에 아이템 추가
        let item1 = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysOriginal), tag: 0)
        let item2 = UITabBarItem(title: "카테고리", image: UIImage(systemName: "square.grid.2x2.fill")?.withRenderingMode(.alwaysOriginal), tag: 1)

        // 사용자 정의 이미지로 지도 아이콘 설정
        let mapImage = UIImage(named: "korea")?.withRenderingMode(.alwaysOriginal) // 이미지의 렌더링 모드 설정
        let resizedMapImage = mapImage?.resize(targetSize: CGSize(width: 30, height: 30)) // 이미지 크기 조정
        let item3 = UITabBarItem(title: "지도", image: resizedMapImage?.withRenderingMode(.alwaysOriginal), tag: 2)

        let item4 = UITabBarItem(title: "캘린더", image: UIImage(systemName: "calendar")?.withRenderingMode(.alwaysOriginal), tag: 3)
        let item5 = UITabBarItem(title: "내 장소", image: UIImage(systemName: "square.and.arrow.down.fill")?.withRenderingMode(.alwaysOriginal), tag: 4)

        
        // 탭바 모양 둥글게 만들기
        tabBar.layer.cornerRadius = 15
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.clipsToBounds = true
        
        tabBar.setItems([item1, item2, item3, item4, item5], animated: false)
        
        // 탭바 제약조건 추가
        NSLayoutConstraint.activate([
            tabBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // + 버튼 추가
        view.addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.heightAnchor.constraint(equalToConstant: 30),
            plusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
        // - 버튼 추가
        view.addSubview(minusButton)
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            minusButton.widthAnchor.constraint(equalToConstant: 30),
            minusButton.heightAnchor.constraint(equalToConstant: 30),
            minusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            minusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
        // 처음에는 다른 탭에서도 키워드가 보이지 않도록 추가
        hideAllKeywords()
        
        // 카테고리 탭에서만 키워드 레이블을 추가
        tabBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 탭바가 배치된 후에 키워드 레이블 위치 조정
        layoutKeywordLabels()
    }
    
    func addKeywordLabels() {
        let keywords = ["액티비티", "공방", "실내", "실외", "기념일"]
        
        // 키워드 텍스트를 표시할 UILabel들을 생성하여 화면 위쪽에 배치
        for (index, keyword) in keywords.enumerated() {
            // UILabel 생성
            let label = UILabel()
            label.text = keyword
            label.textAlignment = .center
            label.backgroundColor = .systemOrange // 주황색으로 변경
            label.layer.cornerRadius = 15 // 둥근 테두리 설정
            label.clipsToBounds = true // 테두리가 잘림 방지
            
            // 배열에 추가
            keywordLabels.append(label)
            
            // UILabel을 화면에 추가
            self.view.addSubview(label)
            
            // 처음 3개의 키워드는 보이도록 설정
            if index < 3 {
                label.isHidden = false
            } else {
                label.isHidden = true
            }
        }
    }
    
    func layoutKeywordLabels() {
        // UILabel의 초기 위치 및 크기 설정
        var xPosition: CGFloat = 20 // 시작 x 위치
        var yPosition: CGFloat = 50 // 시작 y 위치
        let labelHeight: CGFloat = 30 // 높이
        let topMargin: CGFloat = 50 // 위쪽 마진
        
        // UILabel의 위치 조정
        for label in keywordLabels {
            let labelWidth = label.intrinsicContentSize.width + 20 // 라벨의 콘텐츠에 맞는 너비 계산
            // 라벨이 오른쪽으로 나가면 다음 줄로 이동하도록 처리
            if xPosition + labelWidth > view.bounds.width - 20 {
                xPosition = 20 // x 위치 초기화
                yPosition += labelHeight + 10 // 다음 줄로 이동
            }
            label.frame = CGRect(x: xPosition, y: yPosition, width: labelWidth, height: labelHeight)
            
            // x 위치 업데이트
            xPosition += labelWidth + 10 // 간격을 조절하려면 10을 다른 값으로 변경
        }
    }
    
    // + 버튼 탭 핸들러
    @objc func plusButtonTapped() {
        plusButton.isHidden = true
        minusButton.isHidden = false
        showAllKeywords()
    }
    
    // - 버튼 탭 핸들러
    @objc func minusButtonTapped() {
        plusButton.isHidden = false
        minusButton.isHidden = true
        hideAllKeywords()
    }
    
    // 모든 키워드 라벨 표시
    func showAllKeywords() {
        for label in keywordLabels {
            label.isHidden = false
        }
    }
    
    // 처음 3개의 키워드 라벨만 보이도록 설정
    func hideAllKeywords() {
        for (index, label) in keywordLabels.enumerated() {
            if index < 3 {
                label.isHidden = false
            } else {
                label.isHidden = true
            }
        }
    }
}

extension ViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // 카테고리 탭이 선택되었을 때만 키워드 레이블 추가
        if item.title == "카테고리" {
            addKeywordLabels()
            plusButton.isHidden = false
            minusButton.isHidden = true
        } else {
            // 다른 탭이 선택되었을 때는 키워드 레이블 제거
            for label in keywordLabels {
                label.removeFromSuperview()
            }
            keywordLabels.removeAll()
            plusButton.isHidden = true
            minusButton.isHidden = true
        }
    }
}

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // 이미지를 새로운 크기로 그립니다.
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
