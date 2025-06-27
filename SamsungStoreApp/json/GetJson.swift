//
//  getJson.swift
//  bookbook
//
//  Created by Luca Park on 6/12/25.
//

import Foundation

class DataService {
  enum DataError: Error {
    case fileNotFound
    case parsingFailed
  }

  func loadCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
    guard let path = Bundle.main.path(forResource: "Product", ofType: "json") else {
      completion(.failure(DataError.fileNotFound))
      return
    }
    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: path))
      let response = try JSONDecoder().decode(CategoryResponse.self, from: data)
      completion(.success(response.categories))
    } catch {
      print("파싱 에러: \(error)")
      completion(.failure(DataError.parsingFailed))
    }
  }

  func jsonDebug() {
    DataService().loadCategories {
      switch $0 {
      case let .success(categories):
        for category in categories {
          print("- \(category.category)")
          for item in category.items {
            print("  - \(item.name): \(item.price)")
          }
          print("")
        }
      case let .failure(error):
        print("\(error)")
      }
    }
  }
}


// Usage
//override func viewDidLoad() {
//  super.viewDidLoad()
//  // Do any additional setup after loading the view.
//  view.backgroundColor = .systemBlue
//
//  dataService.loadCategories { [weak self] result in
//    switch result {
//    case let .success(loadedCategories):
//      self?.categories = loadedCategories
//      DispatchQueue.main.async {
//        print("✅ 불러온 카테고리 수: \(loadedCategories.count)")
//      }
//    case let .failure(error):
//      print("🚨 데이터 로딩 실패: \(error)")
//    }
//  }
////    dataService.jsonDebug()
//}
