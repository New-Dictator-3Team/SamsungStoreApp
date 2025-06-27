//
//  ViewController.swift
//  SamsungStoreApp
//
//  Created by estelle on 6/26/25.
//

import SnapKit
import UIKit

class ViewController: UIViewController {
  var categories: [Category] = []
  var service: DataService = .init()
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground

    let categoryTab = CategoryTabView()
    view.addSubview(categoryTab)
    categoryTab.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }

    service.loadCategories { [weak self] result in
      switch result {
      case let .success(loadedCategories):
        self?.categories = loadedCategories
        DispatchQueue.main.async {
          print("불러온 카테고리 수: \(loadedCategories.count)")
          let categoryNames = loadedCategories.map { $0.category }
          categoryTab.configure(categories: categoryNames)
        }
      case let .failure(error):
        print("데이터 로딩 실패: \(error)")
      }
    }
  }
}
