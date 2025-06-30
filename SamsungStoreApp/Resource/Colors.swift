import UIKit

enum AppColorType {
  static let primary = UIColor(light: "#2189FF", dark: "#2189FF") // 파랑
  static let secondary = UIColor(light: "#000000", dark: "#FFFFFF") // 검정 <-> 하양
  static let background = UIColor(light: "#FFFFFF", dark: "#1A1A1A") // 하양 <-> 검정
  static let highlight = UIColor(light: "#2189FF", dark: "#2189FF") // 파랑
  static let division = UIColor(light: "#D9D9D9", dark: "#D9D9D9") // 회색
}

extension UIColor {
  // hex로 변환
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
  
  convenience init(light lightHex: String, dark darkHex: String) {
    self.init { traitCollection in
      if traitCollection.userInterfaceStyle == .dark {
        return UIColor(hex: darkHex)
      } else {
        return UIColor(hex: lightHex)
      }
    }
  }
}
