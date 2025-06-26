import UIKit

enum ActionType {
    case clear
    case pay

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
            return AppColorType.background
        }
    }
}

final class BottomButton: UIButton {
    init(title: String, type: ActionType, fontSize: CGFloat) {
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
        layer.cornerRadius = 20
        layer.borderWidth = 2
        layer.borderColor = AppColorType.secondary.cgColor
    }
}
