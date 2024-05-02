//
//  SecondViewController.swift
//  Date_New
//
//  Created by 이슬기 on 4/27/24.
//

import UIKit

class SecondViewController: UIViewController {
    
    // 키워드 레이블을 저장할 배열
    var keywordLabels: [UILabel] = []
    
    // 장소 정보 레이블을 저장할 배열
    var placeInfoLabels: [UILabel] = []
    
    // 장소 정보를 담을 딕셔너리 배열
    let places: [[String: String]] = [
        ["name": "카페", "image": "korea", "description": "카페 장소 설명"],
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
        // 스크롤 뷰 생성
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.layer.borderWidth = 1.0
        scrollView.layer.borderColor = UIColor.lightGray.cgColor
        scrollView.layer.cornerRadius = 10
        scrollView.clipsToBounds = true
        view.addSubview(scrollView)
        
        // 스크롤 뷰 제약 조건 추가
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: keywordLabels.last?.bottomAnchor ?? plusButton.bottomAnchor, constant: 20), // 키워드 라벨 아래에 맞추기
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor) // 기존: view.bottomAnchor
        ])
        
        // 장소 이미지 및 설명 추가
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

    func layoutPlaceContainer() {
        // 아래쪽 여백을 추가할 때 사용할 값
        let bottomPadding: CGFloat = 20
        
        // 스크롤 뷰 제약 조건 수정하여 plusButton의 하단에 맞추고, 스크롤 뷰가 뷰 컨트롤러의 하단까지 확장되도록 설정합니다.
        if let scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: keywordLabels.last?.bottomAnchor ?? plusButton.bottomAnchor, constant: 20), // 키워드 라벨 아래에 맞추기
                scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -bottomPadding)
            ])
        }
    }

    
    // MARK: - Actions

    @objc func filterButtonTapped() {
           let filterViewController = FilterViewController()
           filterViewController.selectedKeywords = selectedKeywords
           filterViewController.modalPresentationStyle = .overFullScreen // 전체 화면으로 표시
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
}
