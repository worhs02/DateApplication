import UIKit

class SecondViewController: UIViewController, FilterDelegate {
    
    // 키워드 레이블을 저장할 배열
    var keywordLabels: [UILabel] = []
    
    // 장소 정보 레이블을 저장할 배열
    var placeInfoLabels: [UILabel] = []
    
    // 장소 정보를 담을 딕셔너리 배열
    let places: [[String: String]] = [
        ["name": "카페", "image": "korea", "description": "실내", "price": "12000"],
        ["name": "공원", "image": "korea", "description": "공원 장소 설명"],
        ["name": "음식점", "image": "korea", "description": "음식점 장소 설명"],
        ["name": "카페", "image": "korea", "description": "카페 장소 설명"],
        ["name": "공원", "image": "korea", "description": "공원 장소 설명"],
        ["name": "음식점", "image": "korea", "description": "음식점 장소 설명"],
        ["name": "카페", "image": "korea", "description": "카페 장소 설명"],
        ["name": "공원", "image": "korea", "description": "공원 장소 설명"],
        ["name": "음식점", "image": "korea", "description": "음식점 장소 설명"]
        // 추가적인 장소는 여기에 계속해서 추가
    ]
    let keywords = ["액티비티", "공방", "실내", "실외", "기념일", "예약가능", "음식저"]
    
    var selectedKeywords: Set<String> = []
    
    var temp: Set<String> = []
    
    // + 버튼
    let plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        button.isHidden = false
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
    
    // 스크롤 뷰
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.layer.borderWidth = 1.0
        scrollView.layer.borderColor = UIColor.lightGray.cgColor
        scrollView.layer.cornerRadius = 10
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        // + 버튼 추가
        view.addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.heightAnchor.constraint(equalToConstant: 30),
            plusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
        // 키워드 라벨 추가
        addKeywordLabels()
        
        // 장소 컨테이너 추가
        view.addSubview(scrollView)
        addPlaceContainer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 탭바가 배치된 후에 키워드 및 장소 정보 레이블 위치 조정
        layoutKeywordLabels()
        layoutPlaceInfoLabels()
        layoutPlaceContainer()
    }
    
    // MARK: - UI Setup
    
    func addKeywordLabels() {
        // 키워드 텍스트를 표시할 UILabel들을 생성하여 화면 위쪽에 배치
        for (index, keyword) in keywords.prefix(3).enumerated() {
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
        view.addSubview(scrollView)
        
        // 스크롤 뷰 제약 조건 추가
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: keywordLabels.last?.bottomAnchor ?? plusButton.bottomAnchor, constant: 20), // 키워드 라벨 아래에 맞추기
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor) // 기존: view.bottomAnchor
        ])
        
        // 장소 이미지 및 설명 추가
        updatePlacesUI(with: places)
    }
    
    func layoutPlaceContainer() {
        // 아래쪽 여백을 추가할 때 사용할 값
        let bottomPadding: CGFloat = 20

        // 스크롤 뷰 제약 조건 수정하여 plusButton의 하단에 맞추고, 스크롤 뷰가 뷰 컨트롤러의 하단까지 확장되도록 설정합니다.
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: keywordLabels.last?.bottomAnchor ?? plusButton.bottomAnchor, constant: 20), // 키워드 라벨 아래에 맞추기
            ])
    }
    
    // 필터 버튼이 탭되었을 때 호출되는 메서드
    @objc func filterButtonTapped() {
        // 필터 뷰 컨트롤러를 초기화합니다.
        
        let filterViewController = FilterViewController()
        
        // 필터 뷰 컨트롤러에 현재 선택된 키워드를 전달합니다.
        filterViewController.selectedKeywords = temp
        
        // 필터 뷰 컨트롤러의 delegate를 현재 뷰 컨트롤러로 설정합니다.
        filterViewController.delegate = self
        
        // 필터 뷰 컨트롤러의 모달 프레젠테이션 스타일을 설정합니다.
        filterViewController.modalPresentationStyle = .overFullScreen
        
        // 필터 뷰 컨트롤러를 화면에 표시합니다.
        present(filterViewController, animated: true, completion: nil)
    }
    
    // 키워드 버튼 탭 핸들러
    @objc func keywordButtonTapped(sender: UIButton) {
        guard let keyword = sender.titleLabel?.text else { return }
        if selectedKeywords.contains(keyword) {
            selectedKeywords.remove(keyword) // 이미 선택된 키워드면 제거
        } else {
            selectedKeywords.insert(keyword) // 선택되지 않은 키워드면 추가
        }
        
        // 버튼의 배경색 업데이트
        sender.backgroundColor = selectedKeywords.contains(keyword) ? .systemBlue : .orange    }
    
    func didApplyFilters(selectedKeywords: Set<String>, selectedPriceRange: String) {
        if selectedKeywords.isEmpty && selectedPriceRange.isEmpty {
            // 필터링된 키워드와 가격대가 없는 경우, 모든 장소를 표시
            updatePlacesUI(with: places)
        } else {
            // 가격대 필터링을 위해 가격대를 범위로 변환합니다.
            let priceRange = convertPriceRange(selectedPriceRange)
            
            // 선택된 키워드와 가격대로 장소를 필터링합니다.
            let filteredPlaces = filterPlaces(by: selectedKeywords, and: priceRange)
             
            temp = selectedKeywords
            
            // 필터링된 장소로 UI를 업데이트합니다.
            updatePlacesUI(with: filteredPlaces)
        }
    }

    // 가격대 문자열을 실제 가격 범위로 변환하는 메서드
    func convertPriceRange(_ priceRange: String) -> ClosedRange<Double> {
        // 예시: "$10 - $20" -> 10.0...20.0로 변환
        let components = priceRange.split(separator: "~")
        if components.count == 2, let lowerBound = Double(components[0].trimmingCharacters(in: .whitespaces)), let upperBound = Double(components[1].trimmingCharacters(in: .whitespaces)) {
            return lowerBound...upperBound
        } else {
            // 변환이 실패하면 기본값을 반환합니다.
            return 0.0...Double.infinity
        }
    }

    // 가격대와 키워드에 따라 장소를 필터링하는 메서드
    func filterPlaces(by keywords: Set<String>?, and priceRange: ClosedRange<Double>?) -> [[String: String]] {
        // 필터링된 장소를 저장할 배열
        var filteredPlaces: [[String: String]] = []
        
        // 장소를 순회하면서 필터링 작업 수행
        for place in places {
            let Hashtag = place["description"] ?? ""
            let priceString = place["price"] ?? "0" // 장소의 가격 정보
            
            // 장소의 가격 정보를 실수로 변환합니다.
            guard let price = Double(priceString) else {
                continue // 가격 정보가 올바르지 않으면 다음 장소로 넘어갑니다.
            }
            
            // 키워드 필터링: 장소의 키워드와 선택된 키워드가 일치하는 경우에만 추가
            let keywordsMatched = keywords == nil || keywords!.isEmpty || keywords!.contains(Hashtag)
            
            // 가격대 필터링: 선택된 가격대와 장소의 가격대가 일치하는 경우에만 추가
            let priceRangeMatched = priceRange == nil || priceRange!.contains(price)
            
            // 키워드와 가격대 모두 일치하는 경우에만 장소를 추가
            if keywordsMatched && priceRangeMatched {
                filteredPlaces.append(place)
            }
            print("Place: \(place["description"] ?? ""), Keywords Matched: \(keywordsMatched), Price Range Matched: \(priceRangeMatched)")
        }
        
        return filteredPlaces
    }

    
    func updatePlacesUI(with places: [[String: String]]) {
        // 이전에 추가된 장소 뷰들을 제거
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        // 새로운 장소 정보를 반영하여 UI 업데이트
        var previousView: UIView?
        for place in places {
            guard let imageName = place["image"], let description = place["description"] else {
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
                // 이미지뷰 제약 조건
                imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
                imageView.topAnchor.constraint(equalTo: previousView?.bottomAnchor ?? scrollView.topAnchor, constant: 20), // 이전 뷰의 하단에 맞춤
                imageView.widthAnchor.constraint(equalToConstant: 100),
                imageView.heightAnchor.constraint(equalToConstant: 100),
                
                // 설명 레이블 제약 조건
                descriptionLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
                descriptionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20), // 이미지뷰의 오른쪽에 배치
                descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
                descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -20)
            ])
            
            // 현재 뷰를 이전 뷰로 설정하여 다음 뷰에 사용
            previousView = imageView
        }
        
        // 스크롤 뷰의 contentSize 설정
        if let lastView = previousView {
            scrollView.bottomAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 20).isActive = true
        }
    }
}
