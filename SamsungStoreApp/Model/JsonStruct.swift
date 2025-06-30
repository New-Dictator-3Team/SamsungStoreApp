import Foundation

// MARK: - ProductItem

struct ProductItem: Decodable {
  let image: String
  let nameKey: String
  let price: String

  var localizedName: String {
    return nameKey.localized
  }
}

// MARK: - Category

struct Category: Decodable {
  let categoryKey: String
  let items: [ProductItem]

  var localizedCategory: String {
    return categoryKey.localized
  }
}

// MARK: - CategoryResponse

struct CategoryResponse: Decodable {
  let categories: [Category]
}
