import UIKit

enum Font {
  static func title(size: CGFloat) -> UIFont {
    return UIFont(name: "samsungsharpsans-bold", size: size) ?? .boldSystemFont(ofSize: size)
  }

  static func text(size: CGFloat) -> UIFont {
    return UIFont(name: "SamsungOneKorean-400", size: size) ?? .systemFont(ofSize: size)
  }
}
