//
//  ViewController.swift
//  SamsungStoreApp
//
//  Created by estelle on 6/26/25.
//

import SnapKit
import UIKit

class ViewController: UIViewController, CategoryTabViewDelegate, ProductPageViewDelegate {
  func didTapCategoryButton(selectedCategoryIndex: Int) {
    let selectedItems = categories[selectedCategoryIndex].items
    productPageView.configure(with: selectedItems)
  }

  func productPageView(_: ProductPageView, didSelect product: ProductItem) {
    print("선택한 상품: \(product.name), 가격: \(product.price)")
    cartViewController.addItem(CartItem(name: product.name, price: Int(product.price) ?? 0, count: 1))
  }

  var categories: [Category] = []
  var service: DataService = .init()
  let productPageView: ProductPageView = .init()
  let categoryTabView: CategoryTabView = .init()
  let cartViewController: CartViewController = .init()
  let bottomView: BottomView = .init()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    view.addSubview(categoryTabView)
    view.addSubview(productPageView)
    view.addSubview(cartViewController.view)
    view.addSubview(bottomView)

    categoryTabView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
    productPageView.snp.makeConstraints {
      $0.top.equalTo(categoryTabView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(cartViewController.view.snp.top)
    }
    cartViewController.view.snp.makeConstraints {
//      $0.top.equalTo(productPageView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(bottomView.snp.top)
      $0.height.equalTo(150)
    }
    bottomView.snp.makeConstraints {
      $0.top.equalTo(cartViewController.view.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
      $0.height.equalTo(50)
    }

    service.loadCategories { [weak self] result in
      guard let self = self else { return }
      switch result {
      case let .success(loadedCategories):
        self.categories = loadedCategories
        DispatchQueue.main.async {
          print("불러온 카테고리 수: \(loadedCategories.count)")
          let categoryNames = loadedCategories.map { $0.category }
          self.categoryTabView.configure(categories: categoryNames)
          self.productPageView.configure(with: loadedCategories[0].items)
        }
      case let .failure(error):
        print("데이터 로딩 실패: \(error)")
      }
    }
    categoryTabView.delegate = self
    productPageView.delegate = self
  }
}
