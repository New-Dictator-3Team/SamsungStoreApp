//
//  MenuCollectionViewController.swift
//  SamsungStoreApp
//
//  Created by 김우성 on 6/26/25.
//

import SnapKit
import UIKit

/// merge 시에 곤란한 일이 발생하지 않기 위해 생성한 ViewController
/// 다른 분들의 뷰를 더미로 생성하고, 그 사이에 제 뷰를 두는 것으로 설정했습니다.
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
    
    category.backgroundColor = AppColorType.primary
//    productPageView.backgroundColor = AppColorType.primary.withAlphaComponent(0.5)
    shoppingCart.backgroundColor = AppColorType.primary
    bottomButton.backgroundColor = AppColorType.primary
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
    
    /// 제가 맡은 뷰의 제약입니다.
    productPageView.snp.makeConstraints {
      $0.top.equalTo(category.snp.bottom)     // 상단은 카테고리 뷰의 하단에
      $0.leading.trailing.equalToSuperview()  // 좌우는 슈퍼뷰와 동일하게
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
    ProductManager.shared.loadProducts()
    guard let mobile = ProductManager.shared.categories?.mobile else { return }
    productPageView.configure(with: mobile)
    productPageView.delegate = self
  }
}

extension MenuCollectionViewController: ProductPageViewDelegate {
  func productPageView(_ view: ProductPageView, didUpdateCategory category: String) {
    print("카테고리 변경됨: \(category)")
  }
  
  func productPageView(_ view: ProductPageView, didSelect product: Product) {
    print("선택된 제품:", product.name)
    
  }
}
