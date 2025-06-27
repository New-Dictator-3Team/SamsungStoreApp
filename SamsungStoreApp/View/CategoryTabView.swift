import UIKit
import SnapKit

class CategoryTabView: UIView {
  
  // 수평 스크롤이 가능한 카테고리 영역
  private let categoryScrollView: UIScrollView = {
      let scrollView = UIScrollView()
      scrollView.showsHorizontalScrollIndicator = false
      return scrollView
  }()
  
  // 버튼들을 담을 스택 뷰 (수평 정렬)
  private let categoryStackView: UIStackView = {
      let stackView = UIStackView()
      stackView.axis = .horizontal
      stackView.spacing = 10
      stackView.alignment = .center
      stackView.distribution = .fillProportionally
      return stackView
  }()
  
  // MARK: - Initializer
  override init(frame: CGRect) {
      super.init(frame: frame)
      setupUI()
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI 세팅
  private func setupUI() {
      addSubview(categoryScrollView)
      categoryScrollView.addSubview(categoryStackView)
      
      setupConstraints()
  }
  
  private func setupConstraints() {
      categoryScrollView.snp.makeConstraints {
          $0.edges.equalToSuperview()
      }
      
      categoryStackView.snp.makeConstraints {
          $0.top.bottom.equalTo(categoryScrollView.frameLayoutGuide).inset(16)
          $0.leading.trailing.equalTo(categoryScrollView.contentLayoutGuide).inset(24)
      }
  }
  
  // MARK: - 카테고리 버튼 목록 구성
  func configure(categories: [String]) {
      
      // 각 카테고리에 대해 버튼 생성 및 추가
      for (index, category) in categories.enumerated() {
          let categoryButton = createCategoryButton(title: category, isSelected: index == 0)
          categoryButton.isSelected = (index == 0)
          
          categoryButton.tag = index
          
          categoryStackView.addArrangedSubview(categoryButton)
      }
  }
  
  // 버튼 스타일 및 애니메이션 설정
  private func createCategoryButton(title: String, isSelected: Bool) -> UIButton {
      var config = UIButton.Configuration.filled()
      config.title = title
      config.titleAlignment = .center
      config.cornerStyle = .capsule
      config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
      config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
          var newAttributes = attributes
          newAttributes.font = Font.text(size: 18)
          return newAttributes
      }
      
      let categoryButton = UIButton(configuration: config)
      categoryButton.isSelected = isSelected
      
      // 그림자 설정
      categoryButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
      categoryButton.layer.shadowOpacity = 1
      categoryButton.layer.shadowOffset = CGSize(width: 0, height: 4)
      categoryButton.layer.shadowRadius = 4
      categoryButton.layer.masksToBounds = false
      
      
      
      return categoryButton
  }
}
