import UIKit

class FilterViewController: UIViewController, FilterDelegate {
    
    weak var delegate: FilterDelegate?

    var selectedKeywords: Set<String> = [] // 선택된 키워드를 저장할 집합
    var priceLabel: UILabel!
    var minPriceLabel: UILabel!
    var maxPriceLabel: UILabel!
    let priceRanges = ["10000원 이하", "10000원 ~ 30000원", "30000 ~ 50000원", "50000원 이상"] // 가격대를 표시하는 라벨을 위한 배열
    var selectedPriceRange: String = ""
    let priceSlider = UISlider()
    


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
        
        //  스택 뷰
        let labelView1 = UIStackView()
        labelView1.axis = .vertical
        labelView1.spacing = 20
        labelView1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelView1)
        
        // 라벨 추가
        let filterLabel = UILabel()
        filterLabel.text = "공간"
        filterLabel.textColor = .black
        filterLabel.textAlignment = .left
        filterLabel.font = UIFont.boldSystemFont(ofSize: 16)
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        labelView1.addArrangedSubview(filterLabel)
        
        // 구분선 추가
        let separatorLine = UIView()
        separatorLine.backgroundColor = .lightGray
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        labelView1.addArrangedSubview(separatorLine)
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        //  스택 뷰
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // 키워드 버튼 추가
        let keywords: [String] = ["실내", "실외"]
        for keyword in keywords {
            let keywordButton = createKeywordButton(title: keyword)
            stackView.addArrangedSubview(keywordButton)
        }
        
        //  스택 뷰
        let labelView2 = UIStackView()
        labelView2.axis = .vertical
        labelView2.spacing = 20
        labelView2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelView2)
        
        // 라벨 추가
        let filterLabel2 = UILabel()
        filterLabel2.text = "종류"
        filterLabel2.textColor = .black
        filterLabel2.textAlignment = .left
        filterLabel2.font = UIFont.boldSystemFont(ofSize: 16)
        filterLabel2.translatesAutoresizingMaskIntoConstraints = false
        labelView2.addArrangedSubview(filterLabel2)
        
        // 구분선 추가
        let separatorLine2 = UIView()
        separatorLine2.backgroundColor = .lightGray
        separatorLine2.translatesAutoresizingMaskIntoConstraints = false
        labelView2.addArrangedSubview(separatorLine2)
        separatorLine2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let secondStackView = UIStackView()
        secondStackView.axis = .horizontal
        secondStackView.spacing = 20
        secondStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(secondStackView)
        
        let remainingKeywords: [String] = ["공방", "액티비티", "수상"]
        for keyword in remainingKeywords {
            let keywordButton = createKeywordButton(title: keyword)
            secondStackView.addArrangedSubview(keywordButton)
        }
        
        //  스택 뷰
        let labelView3 = UIStackView()
        labelView3.axis = .vertical
        labelView3.spacing = 20
        labelView3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelView3)

        // 라벨 추가
        let filterLabel3 = UILabel()
        filterLabel3.text = "가격"
        filterLabel3.textColor = .black
        filterLabel3.textAlignment = .left
        filterLabel3.font = UIFont.boldSystemFont(ofSize: 16)
        filterLabel3.translatesAutoresizingMaskIntoConstraints = false
        labelView3.addArrangedSubview(filterLabel3)

        // 구분선 추가
        let separatorLine3 = UIView()
        separatorLine3.backgroundColor = .lightGray
        separatorLine3.translatesAutoresizingMaskIntoConstraints = false
        labelView3.addArrangedSubview(separatorLine3)
        separatorLine3.heightAnchor.constraint(equalToConstant: 1).isActive = true

        // 가격대 선택을 위한 슬라이더 추가
        priceSlider.minimumValue = 0
        priceSlider.maximumValue = 3
        priceSlider.value = 0 // 기본 선택 인덱스 설정
        
        if !selectedPriceRange.isEmpty {
            // selectedPriceRange가 비어 있지 않은 경우, 해당 범위의 인덱스 찾기
            for (index, range) in priceRanges.enumerated() {
                if selectedPriceRange == range {
                    priceSlider.value = Float(index)
                    break
                }
            }
        }
        
        priceSlider.translatesAutoresizingMaskIntoConstraints = false
        priceSlider.addTarget(self, action: #selector(priceSliderValueChanged(_:)), for: .valueChanged)
        view.addSubview(priceSlider)

        // 최소가격 라벨 추가
        minPriceLabel = UILabel()
        minPriceLabel.textAlignment = .left
        minPriceLabel.font = UIFont.systemFont(ofSize: 14)
        minPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(minPriceLabel)
        
        // 최대가격 라벨 추가
        maxPriceLabel = UILabel()
        maxPriceLabel.textAlignment = .right
        maxPriceLabel.font = UIFont.systemFont(ofSize: 14)
        maxPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(maxPriceLabel)
        
        // 가격대를 표시하는 라벨 추가
        priceLabel = UILabel()
        priceLabel.textAlignment = .center
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.text = selectedPriceRange
        view.addSubview(priceLabel)

        // 가격대 선택에 따라 표시할 가격 문자열 배열
        
        // 적용 버튼
        let confirmButton = UIButton()
        confirmButton.setTitle("적용", for: .normal)
        confirmButton.backgroundColor = .systemBlue
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 10
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmButton)
        
        // 초기화 버튼
        let resetButton = UIButton()
        resetButton.setTitle("초기화", for: .normal)
        resetButton.backgroundColor = .systemBlue
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.cornerRadius = 10
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resetButton)
        
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            labelView1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            labelView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: labelView1.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            labelView2.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            labelView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            secondStackView.topAnchor.constraint(equalTo: labelView2.bottomAnchor, constant: 20),
            secondStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            labelView3.topAnchor.constraint(equalTo: secondStackView.bottomAnchor, constant: 20),
            labelView3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelView3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            minPriceLabel.topAnchor.constraint(equalTo: labelView3.bottomAnchor, constant: 20),
            minPriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            maxPriceLabel.topAnchor.constraint(equalTo: labelView3.bottomAnchor, constant: 20),
            maxPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            priceSlider.topAnchor.constraint(equalTo: minPriceLabel.bottomAnchor, constant: 5),
            priceSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priceSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            priceLabel.topAnchor.constraint(equalTo: priceSlider.bottomAnchor, constant:15),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            resetButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -70),
            resetButton.widthAnchor.constraint(equalToConstant: 100),
            resetButton.heightAnchor.constraint(equalToConstant: 40),
            
            confirmButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 70),
            confirmButton.widthAnchor.constraint(equalToConstant: 100),
            confirmButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // 가격 라벨 초기화
        updatePriceLabels(min: 0, max: 50000) // 초기 값
    }
    
    private func createKeywordButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        
        // Check if the keyword is selected and set button background color accordingly
        button.backgroundColor = selectedKeywords.contains(title) ? .systemBlue : .orange
        
        if selectedKeywords.contains(title) {
            button.isSelected = true
            button.backgroundColor = .systemBlue
        }
        
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(keywordButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        // 버튼 내의 글자 크기 설정
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        // Calculate width based on the text length and font size
        let width = title.size(withAttributes: [.font: UIFont.systemFont(ofSize: 12)]).width + 20 // Add padding
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        // Set fixed height constraint
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
    
    @objc private func priceSliderValueChanged(_ slider: UISlider) {
        let selectedPriceRangeIndex = Int(slider.value)
        let selectedPriceRange = priceRanges[selectedPriceRangeIndex]
        priceLabel.text = selectedPriceRange
    }
    
    @objc private func confirmButtonTapped() {
        let selectedPriceRangeIndex = Int(priceSlider.value)
        let selectedPriceRange = priceRanges[selectedPriceRangeIndex]
                
        if let delegate = delegate {
            delegate.didApplyFilters(selectedKeywords: selectedKeywords, selectedPriceRange: selectedPriceRange)
        
        } else {
            print("Delegate is not set")
        }

        dismiss(animated: true, completion: nil)
    }
    @objc private func resetButtonTapped() {
        
        var selectedKeywords: Set<String> = []
        let selectedPriceRangeIndex = 0
        let selectedPriceRange = priceRanges[selectedPriceRangeIndex]
        
        if let delegate = delegate {
            delegate.didApplyFilters(selectedKeywords: selectedKeywords, selectedPriceRange: selectedPriceRange)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func updatePriceLabels(min: Int, max: Int) {
        minPriceLabel.text = "\(min)원"
        maxPriceLabel.text = "\(max)원+"
    }
    func didApplyFilters(selectedKeywords: Set<String>, selectedPriceRange: String) {
           // 필터 창에서 선택한 정보 처리
           // 필요한 작업 수행
       }
}
