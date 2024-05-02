//
//  FilterViewController.swift
//  Date_New
//
//  Created by 송재곤 on 4/29/24.
//

import UIKit

class FilterViewController: UIViewController {

    var selectedKeywords: Set<String> = [] // 선택된 키워드를 저장할 집합
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // 필터 창 제목 레이블
        let titleLabel = UILabel()
        titleLabel.text = "필터"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // 수직 스택 뷰
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // "실내" 키워드 버튼
        let indoorButton = createKeywordButton(title: "실내")
        stackView.addArrangedSubview(indoorButton)
        
        // "실외" 키워드 버튼
        let outdoorButton = createKeywordButton(title: "실외")
        stackView.addArrangedSubview(outdoorButton)
        
        // 확인 버튼
        let confirmButton = UIButton()
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.backgroundColor = .systemBlue
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 10
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmButton)
        
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            confirmButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.widthAnchor.constraint(equalToConstant: 100),
            confirmButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func createKeywordButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = selectedKeywords.contains(title) ? .systemBlue : .orange
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(keywordButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    @objc private func keywordButtonTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        if selectedKeywords.contains(title) {
            selectedKeywords.remove(title)
            sender.backgroundColor = .orange
        } else {
            selectedKeywords.insert(title)
            sender.backgroundColor = .systemBlue
        }
    }
    
    @objc private func confirmButtonTapped() {
        // 필터 적용 로직 구현
        // 필터 적용 후 선택된 키워드를 다음 화면으로 전달하는 등의 작업을 수행합니다.
        
        dismiss(animated: true, completion: nil)
    }
}
