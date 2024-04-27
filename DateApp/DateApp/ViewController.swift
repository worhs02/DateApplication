import UIKit

class ViewController: UIViewController {
    
    // 탭바 생성
    let tabBar = UITabBar()
    
    // 키워드 레이블을 저장할 배열
    var keywordLabels: [UILabel] = []
    
    // 장소 정보 레이블을 저장할 배열
    var placeInfoLabels: [UILabel] = []
    
    // 장소 정보를 담을 딕셔너리 배열
    let places: [[String: String]] = [
        ["name": "카페", "image": "korea", "description": "카페 장소 설명"],
        ["name": "공원", "image": "korea", "description": "공원 장소 설명"],
        ["name": "음식점", "image": "korea", "description": "음식점 장소 설명"],
        // 추가적인 장소는 여기에 계속해서 추가
    ]
    
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
    
    // 장소 이미지 뷰
    let placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // 장소 설명 레이블
    let placeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .clear
        return label
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
        
        // 카테고리 탭에서만 키워드 및 장소 정보 레이블을 추가
        tabBar.delegate = self
        
        // Initially add place information labels only if "카테고리" tab is selected
        if tabBar.selectedItem?.title == "카테고리" {
            addKeywordLabels()
            addPlaceContainer()
        }
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 탭바가 배치된 후에 키워드 및 장소 정보 레이블 위치 조정
        layoutKeywordLabels()
        layoutPlaceInfoLabels()
        // "카테고리" 탭에서만 스크롤 뷰의 콘텐츠 크기 설정
        if tabBar.selectedItem?.title == "카테고리" {
            layoutPlaceContainer()
        }
    }
    
    func addKeywordLabels() {
        let keywords = ["액티비티", "공방", "실내", "실외", "기념일", "예약가능", "음식저"]
        
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
        var yPosition: CGFloat = 70 // 시작 y 위치
        let labelHeight: CGFloat = 30 // 높이
        
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
    
    
    func layoutPlaceInfoLabels() {
        var yPosition: CGFloat = view.bounds.height - 150 // 시작 y 위치 설정
        let labelWidth: CGFloat = view.bounds.width - 40 // 너비 설정
        let labelHeight: CGFloat = 30 // 높이 설정
        
        // UILabel의 위치 조정
        for label in placeInfoLabels {
            label.frame = CGRect(x: 20, y: yPosition, width: labelWidth, height: labelHeight)
            
            // y 위치 업데이트
            yPosition += labelHeight + 10 // 간격을 조절하려면 10을 다른 값으로 변경
        }
    }
    
    // 장소 이미지 및 설명 추가 함수
    func addPlaceContainer() {
        // 스크롤 뷰 생성
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.layer.borderWidth = 1.0 // 테두리 두께 설정
        scrollView.layer.borderColor = UIColor.lightGray.cgColor // 테두리 색상 설정
        scrollView.layer.cornerRadius = 10 // 테두리의 둥근 정도 설정
        scrollView.clipsToBounds = true // 테두리 외의 내용을 잘라냅니다.
        view.addSubview(scrollView)

        // 스크롤 뷰 제약 조건 추가
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: keywordLabels.last!.bottomAnchor, constant: 20),
            scrollView.bottomAnchor.constraint(equalTo: tabBar.topAnchor)
        ])

        // 장소 이미지 및 설명 추가
        for (index, place) in places.enumerated() {
            guard let name = place["name"], let imageName = place["image"], let description = place["description"] else {
                continue
            }

            // 장소 이미지 설정
            let placeImage = UIImage(named: imageName)
            let imageView = UIImageView(image: placeImage)
            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(imageView)

            // 장소 설명 설정
            let descriptionLabel = UILabel()
            descriptionLabel.text = description
            descriptionLabel.textAlignment = .left
            descriptionLabel.numberOfLines = 0
            descriptionLabel.backgroundColor = .clear
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(descriptionLabel)

            // 제약 조건 추가
            NSLayoutConstraint.activate([
                // 이미지뷰 제약조건
                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: CGFloat(index * 150) + 20),
                imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
                imageView.widthAnchor.constraint(equalToConstant: 100),
                imageView.heightAnchor.constraint(equalToConstant: 100),

                // 설명 레이블 제약조건
                descriptionLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
                descriptionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20), // 이미지뷰의 오른쪽에 배치
                descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
                descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -20)
            ])
        }
    }


    
    // 장소 이미지 및 설명 레이아웃 함수
    func layoutPlaceContainer() {
        // 키워드 아래에 위치하도록 y 위치를 설정
        var yPosition: CGFloat = keywordLabels.last?.frame.maxY ?? 70 // 키워드의 마지막 위치 아래로 설정, 기본값은 70
        yPosition += 20 // 키워드와 간격을 조금 주기 위해 값을 추가

        // 현재 화면 크기에 맞게 스크롤 뷰의 콘텐츠 크기를 설정
        if let scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
            let scrollViewContentSize = CGSize(width: scrollView.bounds.width, height: yPosition + CGFloat(places.count * 150) + 20) // 스크롤 뷰의 높이를 키워드 아래에서부터 시작하도록 설정
            scrollView.contentSize = scrollViewContentSize
        }
    }


    
    // + 버튼 탭 핸들러
    @objc func plusButtonTapped() {
        plusButton.isHidden = true
        minusButton.isHidden = false
        showAllKeywordsPopup()
    }
    
    // - 버튼 탭 핸들러
    @objc func minusButtonTapped() {
        plusButton.isHidden = false
        minusButton.isHidden = true
        hideExtraKeywords()
    }
    
    // 모든 키워드 라벨 표시
    func showAllKeywords() {
        for label in keywordLabels {
            label.isHidden = false
        }
    }
    
    // 추가적인 키워드 라벨 숨김
    func hideExtraKeywords() {
        for (index, label) in keywordLabels.enumerated() {
            if index >= 3 {
                label.isHidden = true
            }
        }
    }
    
    // 처음에는 다른 탭에서도 키워드가 보이지 않도록 설정
    func hideAllKeywords() {
        for label in keywordLabels {
            label.isHidden = true
        }
    }
    
    // 모든 키워드 팝업 창 표시
    func showAllKeywordsPopup() {
        let popupViewController = UIViewController()
        popupViewController.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let popupView = UIView()
        popupView.backgroundColor = .white
        popupView.layer.cornerRadius = 15
        popupView.clipsToBounds = true
        popupViewController.view.addSubview(popupView)
        
        // 팝업 창 제약 조건 설정
        popupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupView.topAnchor.constraint(equalTo: popupViewController.view.topAnchor, constant: 10),
            popupView.leadingAnchor.constraint(equalTo: popupViewController.view.leadingAnchor, constant: 20),
            popupView.trailingAnchor.constraint(equalTo: popupViewController.view.trailingAnchor, constant: -20),
            popupView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20) // 최소 높이 설정
        ])

        var previousLabel: UILabel?
        for (index, keyword) in keywordLabels.enumerated() {
            let popupKeywordLabel = UILabel()
            popupKeywordLabel.text = keyword.text
            popupKeywordLabel.textAlignment = .center
            popupKeywordLabel.backgroundColor = keyword.backgroundColor
            popupKeywordLabel.layer.cornerRadius = keyword.layer.cornerRadius
            popupKeywordLabel.clipsToBounds = true
            popupKeywordLabel.translatesAutoresizingMaskIntoConstraints = false
            popupView.addSubview(popupKeywordLabel)
            
            // contentCompressionResistancePriority 및 contentHuggingPriority 설정
            popupKeywordLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
            popupKeywordLabel.setContentHuggingPriority(.required, for: .horizontal)
            
            // 라벨 제약 조건 설정
            let itemWidth: CGFloat = 100 // 라벨의 너비 설정
            let leadingMargin: CGFloat = 20 // 왼쪽 여백 설정
            let trailingMargin: CGFloat = 20 // 오른쪽 여백 설정
            NSLayoutConstraint.activate([
                popupKeywordLabel.heightAnchor.constraint(equalToConstant: 30),
                popupKeywordLabel.widthAnchor.constraint(equalToConstant: itemWidth),
                popupKeywordLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: leadingMargin),
                popupKeywordLabel.trailingAnchor.constraint(lessThanOrEqualTo: popupView.trailingAnchor, constant: -trailingMargin)
            ])
            
            if let previousLabel = previousLabel {
                // 이전 라벨이 있는 경우 현재 라벨의 상단을 이전 라벨의 하단과 일치시킴
                popupKeywordLabel.topAnchor.constraint(equalTo: previousLabel.bottomAnchor, constant: 10).isActive = true
            } else {
                // 첫 번째 라벨의 경우 팝업 뷰의 상단에 고정
                popupKeywordLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 20).isActive = true
            }
            
            // 마지막 라벨을 저장하여 다음 라벨에 사용
            previousLabel = popupKeywordLabel

            // 라벨 내용에 맞게 크기 조절
            popupKeywordLabel.sizeToFit()
        }

        // 마지막 라벨의 하단을 팝업 뷰의 하단과 일치시킴
        if let lastLabel = previousLabel {
            lastLabel.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -20).isActive = true
        }
        
        self.present(popupViewController, animated: true, completion: nil)
    }



}

extension ViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // 카테고리 탭이 선택되었을 때만 키워드 및 장소 정보 레이블을 추가
        if item.title == "카테고리" {
            addKeywordLabels()
            addPlaceContainer()
            plusButton.isHidden = false
            minusButton.isHidden = true
        } else {
            // 다른 탭이 선택되었을 때는 키워드 및 장소 정보 레이블을 제거
            for label in keywordLabels {
                label.removeFromSuperview()
            }
            keywordLabels.removeAll()
            
            for label in placeInfoLabels {
                label.removeFromSuperview()
            }
            placeInfoLabels.removeAll()
            placeImageView.removeFromSuperview()
            placeDescriptionLabel.removeFromSuperview()
            
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
