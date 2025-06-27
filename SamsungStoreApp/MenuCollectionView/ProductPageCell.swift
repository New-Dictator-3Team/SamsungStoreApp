//
//  ProductPageCell.swift
//  SamsungStoreApp
//
//  Created by 김우성 on 6/27/25.
//

import SnapKit
import UIKit

final class ProductPageCell: UICollectionViewCell {
  // MARK: -

  private let verticalStack = UIStackView() // 수직 스택
  private var cells: [ProductGridCell] = []
  var tapHandler: ((ProductItem) -> Void)?

  // MARK: -

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupLayout()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: -

  private func setupView() {
    verticalStack.axis = .vertical
    verticalStack.spacing = 24
    verticalStack.distribution = .fillEqually
    contentView.addSubview(verticalStack) // 컨텐츠 뷰에 수직 스택을 넣음. 그 수직 스택에는 수평 스택이 들어 있다.

    // 2 rows
    for _ in 0..<2 {
      let rowStack = UIStackView()
      rowStack.axis = .horizontal
      rowStack.spacing = 24
      rowStack.distribution = .fillEqually

      for _ in 0..<2 {
        let cell = ProductGridCell()
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:))))
        cells.append(cell)
        rowStack.addArrangedSubview(cell)
      }
      verticalStack.addArrangedSubview(rowStack)
    }
  }

  private func setupLayout() {
    verticalStack.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(24)
    }
  }

  // MARK: -
  
  func configure(with products: [ProductItem]) {
    for (index, cell) in cells.enumerated() {
      if index < products.count {
        cell.isHidden = false
        cell.product = products[index]
      } else {
        cell.isHidden = true
      }
    }
  }

  @objc private func cellTapped(_ sender: UITapGestureRecognizer) {
    guard let cell = sender.view as? ProductGridCell,
          let product = cell.product else { return }
    tapHandler?(product)
  }
}
