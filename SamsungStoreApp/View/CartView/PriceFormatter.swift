//
//  PriceFormatter.swift
//  SamsungStoreApp
//
//  Created by 서광용 on 6/29/25.
//

import Foundation

enum PriceFormatter {
  // Int → String (ex. 1000000 → "1,000,000")
  static func format(_ price: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
  }

  // String → Int (ex. "1,000,000" → 1000000)
  static func format(_ price: String) -> Int {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter.number(from: price)?.intValue ?? 0
  }
}
