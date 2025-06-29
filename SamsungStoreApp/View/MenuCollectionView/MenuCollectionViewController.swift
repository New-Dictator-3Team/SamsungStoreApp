//
//  MenuCollectionViewController.swift
//  SamsungStoreApp
//
//  Created by 김우성 on 6/26/25.
//

import SnapKit
import UIKit

// SceneDelegate에서 이 뷰컨트롤러를 root로 설정하고 보시면 됩니다.
final class MenuCollectionViewController: UIViewController {
  // MARK: - 프로퍼티
  
  private var categories: [Category] = []
  private var selectedCategory = "모바일"
  private let dataService = DataService()
  
  private let mainView = UIView()
  private let categoryTabView = CategoryTabView()
  private let productPageView = ProductPageView()
  private let shoppingCart = UIView() // 더미
  private let bottomView = BottomView()
  
  // MARK: - 라이프사이클
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupLayout()
    loadCategoryData()
  }
  
  // MARK: - UI 세팅
  
  private func setupUI() {
    view.backgroundColor = .systemBackground
    view.addSubview(mainView)
    
    [categoryTabView, productPageView, shoppingCart, bottomView].forEach {
      mainView.addSubview($0)
    }
    
    categoryTabView.delegate = self
    productPageView.delegate = self
    
    shoppingCart.backgroundColor = AppColorType.primary
  }
  
  private func setupLayout() {
    mainView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    categoryTabView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(76)
    }
    
    productPageView.snp.makeConstraints {
      $0.top.equalTo(categoryTabView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(shoppingCart.snp.top)
    }
    
    shoppingCart.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(bottomView.snp.top)
      $0.height.equalTo(258)
    }
    
    bottomView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(52)
    }
  }
  
  // MARK: - 데이터 바인딩
  
  private func loadCategoryData() {
    dataService.loadCategories { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let loadedCategories):
        self.categories = loadedCategories
        DispatchQueue.main.async {
          self.categoryTabView.configure(categories: loadedCategories.map { $0.category })
          if let defaultItems = loadedCategories.first(
            where: {
              $0.category == self.selectedCategory
            })?.items {
            print("✅ 불러온 카테고리 수: \(loadedCategories.count)")
            self.productPageView.configure(with: defaultItems)
          }
        }
      case let .failure(error):
        print("🚨 데이터 로딩 실패: \(error)")
      }
    }
//    dataService.jsonDebug()
  }
}

// MARK: - 델리게이트

extension MenuCollectionViewController: CategoryTabViewDelegate {
    func didTapCategoryButton(selectedCategoryIndex: Int) {
        let category = categories[selectedCategoryIndex]
        selectedCategory = category.category
        productPageView.configure(with: category.items)
    }
}

// 아래 델리게이트 익스텐션은 마음대로 수정하셔도 됩니다.
extension MenuCollectionViewController: ProductPageViewDelegate {
  func productPageView(_ view: ProductPageView, didSelect product: ProductItem) {
    print("선택된 제품:", product.name)
  }
}
