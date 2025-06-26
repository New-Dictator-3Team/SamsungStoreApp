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
}

final class CategoryButton: UIButton {
  init(title: String, type: CategoryActionType, fontSize: CGFloat) {
    super.init(frame: .zero)
    setup(title: title, type: type, fontSize: fontSize)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup(title: String, type: CategoryActionType, fontSize: CGFloat) {
    setTitle(title, for: .normal)
    setTitleColor(type.textColor, for: .normal)
    titleLabel?.font = Font.text(size: fontSize)
    backgroundColor = type.backgroundColor
    layer.cornerRadius = 20
  }
}
