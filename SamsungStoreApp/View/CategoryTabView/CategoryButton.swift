import UIKit

enum CategoryActionType {
  case active // 선택된 버튼
  case inactive // 선택되지 않은 버튼
  
  var backgroundColor: UIColor {
    switch self {
    case .active:
      return AppColorType.highlight
    case .inactive:
      return AppColorType.background
    }
  }
  
  var textColor: UIColor {
    switch self {
    case .active:
      return AppColorType.background
    case .inactive:
      return AppColorType.secondary
    }
  }
  
  // 스타일 설정
  func configuration(for title: String, fontSize: CGFloat) -> UIButton.Configuration {
    var config = UIButton.Configuration.filled()
    config.title = title
    config.titleAlignment = .center
    config.cornerStyle = .capsule
    config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
    
    config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
      var newAttributes = attributes
      newAttributes.font = Font.text(size: fontSize)
      return newAttributes
    }
    
    config.baseBackgroundColor = self.backgroundColor
    config.baseForegroundColor = self.textColor
    
    return config
  }
}

final class CategoryButton: UIButton {
  
  private var fontSize: CGFloat = 18
  private var title: String = ""
  
  init(title: String, type: CategoryActionType = .inactive, fontSize: CGFloat) {
    self.title = title
    self.fontSize = fontSize
    super.init(frame: .zero)
    setup(type: type)
    setupShadow()
  }
  
  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup(type: CategoryActionType) {
    self.configuration = type.configuration(for: title, fontSize: fontSize)
    
    // 선택 상태에 따라 색상/변형 조정
    self.configurationUpdateHandler = { [weak self] button in
      guard let self = self else { return }
      let type: CategoryActionType = button.isSelected ? .active : .inactive
      button.configuration = type.configuration(for: self.title, fontSize: self.fontSize)
    }
  }
  
  // 그림자 설정
  private func setupShadow() {
    layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
    layer.shadowOpacity = 1
    layer.shadowOffset = CGSize(width: 0, height: 4)
    layer.shadowRadius = 4
    layer.masksToBounds = false
  }
  
  // 크기 변화 애니메이션
  override var isSelected: Bool {
    didSet {
      UIView.animate(withDuration: 0.25) {
        self.transform = self.isSelected ? CGAffineTransform(scaleX: 1.06, y: 1.06) : .identity
      }
    }
  }
}
