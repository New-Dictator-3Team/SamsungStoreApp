import UIKit

enum AppColorType {
  static let primary = UIColor(hex: "#2189FF") // 파랑
  static let secondary = UIColor(hex: "#000000") //검정
  static let background = UIColor(hex: "#FFFFFF") //하양
  static let highlight = UIColor(hex: "#2189FF") // 파랑
  static let division = UIColor(hex: "#D9D9D9") // 회색
}

extension UIColor {
  //hex로 변환
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let b = CGFloat(rgb & 0x0000FF) / 255

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
