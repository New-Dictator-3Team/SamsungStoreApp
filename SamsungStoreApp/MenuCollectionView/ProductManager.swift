//
//  ProductManager.swift
//  SamsungStoreApp
//
//  Created by 김우성 on 6/27/25.
//

import Foundation

final class ProductManager {
  static let shared = ProductManager()
  
  private init() {}
  
  private(set) var categories: ProductCategory?
  
  func loadProducts() {
    guard let url = Bundle.main.url(forResource: "products", withExtension: "json") else {
      print("❌ products.json 파일을 찾을 수 없습니다.")
      return
    }
    
    do {
      let data = try Data(contentsOf: url)
      categories = try JSONDecoder().decode(ProductCategory.self, from: data)
    } catch {
      print("❌ JSON 파싱 오류:", error)
    }
  }
}
