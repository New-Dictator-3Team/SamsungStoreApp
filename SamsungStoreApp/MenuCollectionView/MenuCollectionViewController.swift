//
//  MenuCollectionViewController.swift
//  SamsungStoreApp
//
//  Created by 김우성 on 6/26/25.
//

import SnapKit
import UIKit

class MenuCollectionViewController: UIViewController {
  // MARK: - 프로퍼티
  
  private var categories: [Category] = []
  private var selectedCategory: String = "모바일"
  private let dataService = DataService()
  
  private let mainView = UIView() // 더미 메인뷰
  
  private let categoryTabView = CategoryTabView()
  private let productPageView = ProductPageView()
  private let shoppingCart = UIView() // 더미
  private let bottomButton = UIView() // 더미
  
  // MARK: - 라이프사이클
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("view 잘 로드됨")
    setupView()
    setupConstraints()
    bindProducts()
  }
  
  // MARK: - 뷰 셋업
  
  private func setupView() {
    view.backgroundColor = .systemBackground
    view.addSubview(mainView)
    
    mainView.addSubview(categoryTabView)
    mainView.addSubview(productPageView)
    mainView.addSubview(shoppingCart)
    mainView.addSubview(bottomButton)
    
    categoryTabView.delegate = self
    
//    categoryTabView.backgroundColor = AppColorType.primary
//    productPageView.backgroundColor = AppColorType.primary.withAlphaComponent(0.5)
    shoppingCart.backgroundColor = AppColorType.primary
    bottomButton.backgroundColor = AppColorType.primary
  }
  
  private func setupConstraints() {
    mainView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    categoryTabView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(76)
    }
    
    /// 제가 맡은 뷰의 제약입니다.
    productPageView.snp.makeConstraints {
      $0.top.equalTo(categoryTabView.snp.bottom) // 상단은 카테고리 뷰의 하단에
      $0.leading.trailing.equalToSuperview() // 좌우는 슈퍼뷰와 동일하게
      $0.bottom.equalTo(shoppingCart.snp.top) // 하단은 쇼핑카트 뷰의 상단에
    }
    
    shoppingCart.snp.makeConstraints {
      $0.bottom.equalTo(bottomButton.snp.top)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(258)
    }
    
    bottomButton.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(52)
    }
  }
  
  private func bindProducts() {
    dataService.loadCategories { [weak self] result in
      switch result {
      case let .success(loadedCategories):
        self?.categories = loadedCategories
        DispatchQueue.main.async {
          guard let self = self else { return }
          self.categoryTabView.configure(categories: loadedCategories.map { $0.category })
          let defaultItems = self.categories.first(where: { $0.category == self.selectedCategory })?.items ?? []
          print("✅ 불러온 카테고리 수: \(loadedCategories.count)")
          self.productPageView.configure(with: defaultItems)
          self.productPageView.delegate = self
        }
      case let .failure(error):
        print("🚨 데이터 로딩 실패: \(error)")
      }
    }

//    dataService.jsonDebug()
  }
}

extension MenuCollectionViewController: ProductPageViewDelegate {
  func productPageView(_ view: ProductPageView, didSelect product: ProductItem) {
    print("선택된 제품:", product.name)
  }
}

extension MenuCollectionViewController: CategoryTabViewDelegate {
  func didTapCategoryButton(selectedCategoryIndex: Int) {
    self.selectedCategory = categories[selectedCategoryIndex].category
    let items = categories[selectedCategoryIndex].items
    productPageView.configure(with: items)
    productPageView.delegate = self
  }
}
