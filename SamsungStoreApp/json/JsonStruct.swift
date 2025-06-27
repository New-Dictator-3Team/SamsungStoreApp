import Foundation

// MARK: - ProductItem

struct ProductItem: Decodable {
  let name: String
  let price: String
}

// MARK: - Category

struct Category: Decodable {
  let category: String
  let items: [ProductItem]
}

// MARK: - CategoryResponse

struct CategoryResponse: Decodable {
  let categories: [Category]
}
