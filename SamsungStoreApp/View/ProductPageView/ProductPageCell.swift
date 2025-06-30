//
//  ProductPageCell.swift
//  SamsungStoreApp
//
//  Created by 김우성 on 6/27/25.
//

import SnapKit
import UIKit

final class ProductPageCell: UICollectionViewCell {
  // MARK: - UI 컴포넌트
  
  private let verticalStack = UIStackView() // 수직 스택
  private var cells: [ProductGridCell] = []
  
  // MARK: - 핸들러
  
  var tapHandler: ((ProductItem) -> Void)?
  
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
    verticalStack.axis = .vertical
    verticalStack.spacing = 16
    verticalStack.distribution = .fillEqually
    contentView.addSubview(verticalStack)
    
    for _ in 0..<2 {
      let rowStack = UIStackView()
      rowStack.axis = .horizontal
      rowStack.spacing = 16
      rowStack.distribution = .fillEqually
      
      for _ in 0..<2 {
        let grid = ProductGridCell()
        grid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:))))
        rowStack.addArrangedSubview(grid)
        cells.append(grid)
      }
      verticalStack.addArrangedSubview(rowStack)
    }
  }
  
  private func setupLayout() {
    verticalStack.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(8)
      $0.leading.trailing.equalToSuperview().inset(16)
    }
  }
  
  // MARK: - 구성
  
  func configure(with products: [ProductItem]) {
    for (index, cell) in cells.enumerated() {
      if index < products.count {
        cell.isHidden = false
        cell.product = products[index]
      } else {
        cell.isHidden = true
        cell.product = nil
      }
    }
    
    for (rowIndex, rowStack) in verticalStack.arrangedSubviews.enumerated() {
      guard let rowStack = rowStack as? UIStackView else { continue }
      
      // 먼저 기존 spacer 뷰가 있다면 제거
      rowStack.arrangedSubviews
        .filter { !($0 is ProductGridCell) }
        .forEach { $0.removeFromSuperview() }
      
      // row별 유효 셀 개수 계산
      let startIndex = rowIndex * 2
      let endIndex = min(startIndex + 2, products.count)
      let visibleCount = endIndex - startIndex
      
      if visibleCount == 1 {
        // 한 셀만 있을 경우, 나머지 공간 채우기용 UIView 추가
        let spacer = UIView()
        rowStack.addArrangedSubview(spacer)
      }
    }
  }
  
  // MARK: - 액션
  
  @objc private func cellTapped(_ sender: UITapGestureRecognizer) {
    guard let cell = sender.view as? ProductGridCell,
          let product = cell.product else { return }
    tapHandler?(product)
  }
}
