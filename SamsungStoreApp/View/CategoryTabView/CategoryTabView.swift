//
//  CategoryTabView.swift
//  SamsungStoreApp
//
//  Created by estelle on 6/27/25.
//

import SnapKit
import UIKit

// 카테고리 탭 선택 시 외부에 알리는 delegate
protocol CategoryTabViewDelegate: AnyObject {
  func didTapCategoryButton(selectedCategoryIndex: Int)
}

class CategoryTabView: UIView {
  weak var delegate: CategoryTabViewDelegate?
  
  // 수평 스크롤이 가능한 카테고리 영역
  private let categoryScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsHorizontalScrollIndicator = false
    return scrollView
  }()
  
  // 버튼들을 담을 스택 뷰 (수평 정렬)
  private let categoryStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 10
    stackView.alignment = .center
    stackView.distribution = .fillProportionally
    return stackView
  }()
  
  // MARK: - Initializer
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI 세팅
  
  private func setupUI() {
    addSubview(categoryScrollView)
    categoryScrollView.addSubview(categoryStackView)
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    categoryScrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    categoryStackView.snp.makeConstraints {
      $0.top.bottom.equalTo(categoryScrollView.frameLayoutGuide).inset(16)
      $0.leading.trailing.equalTo(categoryScrollView.contentLayoutGuide).inset(16)
    }
  }
  
  // MARK: - 카테고리 버튼 목록 구성
  
  func configure(categories: [String]) {
    // 각 카테고리에 대해 버튼 생성 및 추가
    for (index, category) in categories.enumerated() {
      let categoryButton = CategoryButton(title: category, fontSize: 18)
      categoryButton.isSelected = (index == 0)
      categoryButton.tag = index
      categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
      
      categoryStackView.addArrangedSubview(categoryButton)
    }
  }
  
  
  // MARK: - 버튼 클릭 처리
  
  @objc private func categoryButtonTapped(_ sender: UIButton) {
    let selectedCategoryIndex = sender.tag
    updateButtonState(index: selectedCategoryIndex)
    delegate?.didTapCategoryButton(selectedCategoryIndex: selectedCategoryIndex)
  }
  
  func updateButtonState(index: Int) {
    // 버튼 선택 상태 업데이트
    let buttons = categoryStackView.arrangedSubviews.compactMap { $0 as? UIButton }
    for button in buttons {
      button.isSelected = (button.tag == index)
    }
    
    // 선택된 버튼을 스크롤뷰 가운데로 이동
    if let selectedButton = buttons.first(where: { $0.tag == index }) {
      let buttonFrameInScrollView = selectedButton.convert(selectedButton.bounds, to: categoryScrollView)
      let scrollWidth = categoryScrollView.bounds.width
      let targetX = buttonFrameInScrollView.midX - (scrollWidth / 2)
      
      let maxOffsetX = categoryScrollView.contentSize.width - scrollWidth
      let offsetX = max(min(targetX, maxOffsetX), 0)
      
      categoryScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
  }
}
