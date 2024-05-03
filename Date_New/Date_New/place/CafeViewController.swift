//
//  PlaceDetailViewController.swift
//  Date_New
//
//  Created by 송재곤 on 5/4/24.
//

import UIKit

class CafeViewController: UIViewController {
    
    var placeImage: UIImage?
    var placeDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 장소 이미지 뷰 설정
        let imageView = UIImageView(image: placeImage)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        // 새 이미지를 가져옵니다. 여기에서는 "newImageName"에 새 이미지의 이름을 넣어주세요.
        let newImage = UIImage(named: "korea")

        // 이미지 뷰의 이미지를 새 이미지로 변경합니다.
        imageView.image = newImage
        
        // 장소 설명 레이블 설정
        let descriptionLabel = UILabel()
        descriptionLabel.text = placeDescription
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        
        // 스택 뷰에 이미지 뷰 및 설명 레이블 추가
        let stackView = UIStackView(arrangedSubviews: [imageView, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        // 스택 뷰를 뷰 컨트롤러의 뷰에 추가
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
}

