//
//  ProductGridCell.swift
//  SamsungStoreApp
//
//  Created by 김우성 on 6/27/25.
//

import UIKit
import SnapKit

class ProductGridCell: UIView {
  let imageView = UIImageView()
  let nameLabel = UILabel()
  let priceLabel = UILabel()
  
  var product: Product? {
    didSet {
      imageView.image = UIImage(named: product?.image ?? "placeholder")
      nameLabel.text = product?.name ?? "-"
      priceLabel.text = "\(product?.price.formatted(.number.grouping(.automatic)) ?? "0") 원"
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    backgroundColor = .white
    layer.cornerRadius = 8
    layer.borderWidth = 0.5
    layer.borderColor = UIColor.lightGray.cgColor
    clipsToBounds = true
    
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .lightGray
    
    nameLabel.font = .systemFont(ofSize: 14, weight: .medium)
    nameLabel.textAlignment = .center
    priceLabel.font = .systemFont(ofSize: 13)
    priceLabel.textColor = .secondaryLabel
    priceLabel.textAlignment = .center
    
    let stack = UIStackView(arrangedSubviews: [imageView, nameLabel, priceLabel])
    stack.axis = .vertical
    stack.spacing = 6
    addSubview(stack)
    
    stack.snp.makeConstraints {
      $0.top.equalToSuperview().inset(8)
      $0.bottom.equalToSuperview().inset(8)
      $0.leading.equalToSuperview().inset(8)
      $0.trailing.equalToSuperview().inset(8)
    }
    
    imageView.snp.makeConstraints {
      $0.height.equalToSuperview().multipliedBy(0.6)
    }
  }
}
