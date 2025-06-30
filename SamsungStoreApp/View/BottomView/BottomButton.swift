import UIKit

enum ActionType {
  case clear  // 전체 취소
  case pay    // 결제하기

  var backgroundColor: UIColor {
    switch self {
    case .clear:
      return AppColorType.background
    case .pay:
      return AppColorType.secondary
    }
  }

  var textColor: UIColor {
    switch self {
    case .clear:
      return AppColorType.secondary
    case .pay:
      return AppColorType.highlight
    }
  }
}

final class BottomButton: UIButton {
  init(title: String, type: ActionType, fontSize: CGFloat = 14) {
    super.init(frame: .zero)
    setup(title: title, type: type, fontSize: fontSize)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup(title: String, type: ActionType, fontSize: CGFloat) {
    setTitle(title, for: .normal)
    setTitleColor(type.textColor, for: .normal)
    titleLabel?.font = Font.text(size: fontSize)
    backgroundColor = type.backgroundColor
    layer.cornerRadius = 15
    layer.borderWidth = 2
    layer.borderColor = AppColorType.secondary.cgColor
  }
  
  override func layoutSubviews() { // 높이값이 정해진 후에 이 함수가 호출됨
    super.layoutSubviews()
    layer.cornerRadius = bounds.height / 2 // 둥글어짐
  }
  
  func setAction(_ target: Any?, action: Selector) {
    self.addTarget(target, action: action, for: .touchUpInside)
  }
}
// MARK: Usage

//let clearButton = BottomButton(title: "취소", type: .clear, fontSize: 20)
//let payButton = BottomButton(title: "결제", type: .pay, fontSize: 20)

//let testStack = UIStackView(arrangedSubviews: [clearButton, payButton])
//view.addSubview(testStack)
//testStack.axis = .horizontal
//testStack.spacing = 20
//testStack.snp.makeConstraints {
//  $0.center.equalToSuperview()
//  $0.leading.trailing.equalToSuperview()
//  $0.top.bottom.equalToSuperview().inset(20)
//}
