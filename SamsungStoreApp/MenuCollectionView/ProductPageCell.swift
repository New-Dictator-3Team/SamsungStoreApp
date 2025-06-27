//
//  ProductPageCell.swift
//  SamsungStoreApp
//
//  Created by 김우성 on 6/27/25.
//

import UIKit
import SnapKit

final class ProductPageCell: UICollectionViewCell {
  private let verticalStack = UIStackView()
  private var cells: [ProductGridCell] = []
  var tapHandler: ((Product) -> Void)?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupView() {
    verticalStack.axis = .vertical
    verticalStack.spacing = 12
    verticalStack.distribution = .fillEqually
    contentView.addSubview(verticalStack)
    
    // 2 rows
    for _ in 0..<2 {
      let rowStack = UIStackView()
      rowStack.axis = .horizontal
      rowStack.spacing = 12
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
      $0.edges.equalToSuperview().inset(12)
    }
  }

  func configure(with products: [Product]) {
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
