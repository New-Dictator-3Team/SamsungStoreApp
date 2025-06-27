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
  
  private let mainView = UIView() // 더미 메인뷰
  
  private let category = UIView() // 더미
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
    
    mainView.addSubview(category)
    mainView.addSubview(productPageView)
    mainView.addSubview(shoppingCart)
    mainView.addSubview(bottomButton)
    
//    category.backgroundColor = .red.withAlphaComponent(0.3)
//    productPageView.backgroundColor = .blue.withAlphaComponent(0.3)
//    shoppingCart.backgroundColor = .yellow.withAlphaComponent(0.3)
//    bottomButton.backgroundColor = .green.withAlphaComponent(0.3)
  }
  
  private func setupConstraints() {
    mainView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    category.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(76)
    }
    
    productPageView.snp.makeConstraints {
      $0.top.equalTo(category.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(shoppingCart.snp.top)
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
    ProductManager.shared.loadProducts()
    guard let mobile = ProductManager.shared.categories?.mobile else { return }
    productPageView.configure(with: mobile)
    productPageView.delegate = self
  }
}

extension MenuCollectionViewController: ProductPageViewDelegate {
  func productPageView(_ view: ProductPageView, didSelect product: Product) {
    print("선택된 제품:", product.name)
  }
}
