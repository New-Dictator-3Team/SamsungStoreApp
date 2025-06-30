//
//  ScrollProductCartView.swift
//  SamsungStoreApp
//
//  Created by 김우성 on 6/30/25.
//

import SnapKit
import UIKit

// MARK: - ScrollProductCartView

final class ScrollProductCartView: UIScrollView {
  
  // MARK: - UI 컴포넌트
  
  let stackView = UIStackView()
  let productPageView = ProductPageView()
  let cartView = CartView()
  
  // MARK: - 초기화
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupLayout()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI 세팅
  
  private func setupUI() {
    addSubview(stackView)
    stackView.axis = .vertical
    stackView.spacing = 0
    
    for item in [productPageView, cartView] {
      stackView.addArrangedSubview(item)
    }
  }
  
  private func setupLayout() {
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.width.equalToSuperview() // 중요함
    }
    
    productPageView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(436)
    }
    
    cartView.snp.makeConstraints {
      $0.top.equalTo(productPageView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.height.equalTo(200) // 컨텐츠 길이에 따라 유동적으로 바뀌게 하시려면 지울 필요가 있습니다
    }
  }
}
