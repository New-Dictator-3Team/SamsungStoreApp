//
//  ViewController.swift
//  SamsungStoreApp
//
//  Created by estelle on 6/26/25.
//

import SnapKit
import UIKit

final class ViewController: UIViewController {
  // MARK: - 프로퍼티

  var categories: [Category] = []
  var cartItems: [CartItem] = []
  private var selectedCategory = "모바일"
  private let dataService = DataService()
  
  private let mainView = UIView()
  private let categoryTabView = CategoryTabView()
  
  let productPageView = ProductPageView()
  private let cartView = CartView()
  
  private let summaryView = CartSummaryView()
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
      
    for item in [categoryTabView, productPageView, cartView, summaryView, bottomView] {
      mainView.addSubview(item)
    }
      
    categoryTabView.delegate = self
    productPageView.delegate = self
    cartView.delegate = self
  }
    
  private func setupLayout() {
    mainView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
      
    categoryTabView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(65)
    }
      
    productPageView.snp.makeConstraints {
      $0.top.equalTo(categoryTabView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      //$0.bottom.equalTo(cartView.snp.top)
      $0.height.equalTo(436)
    }
      
    cartView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(summaryView.snp.top)
      $0.top.equalTo(productPageView.snp.bottom)
      //$0.height.equalTo(200)
    }
      
    summaryView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(bottomView.snp.top)
      $0.height.equalTo(80) // 높이 80 고정
    }
      
    bottomView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(50)
    }
  }
    
  // MARK: - 데이터 바인딩
    
  private func loadCategoryData() {
    dataService.loadCategories { [weak self] result in
      guard let self = self else { return }
      switch result {
      case let .success(loadedCategories):
        self.categories = loadedCategories
        DispatchQueue.main.async {
          self.categoryTabView.configure(categories: loadedCategories.map { $0.category })
          if let defaultItems = loadedCategories.first(
            where: {
              $0.category == self.selectedCategory
            })?.items
          {
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
  
  func updateCartView() {
    let totalCount = cartItems.reduce(0) { $0 + $1.count }
    let totalPrice = cartItems.reduce(0) { $0 + ($1.price * $1.count) }
    cartView.reload(with: cartItems, totalCount: totalCount, totalPrice: totalPrice)
    summaryView.configure(itemCount: totalCount, totalPrice: totalPrice)
  }
}
