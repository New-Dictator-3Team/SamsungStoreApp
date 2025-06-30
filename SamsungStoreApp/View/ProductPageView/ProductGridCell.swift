//
//  ProductGridCell.swift
//  SamsungStoreApp
//
//  Created by 김우성 on 6/27/25.
//

import SnapKit
import UIKit

final class ProductGridCell: UIView {
  // MARK: - UI 컴포넌트
  
  let imageView = UIImageView()
  let nameLabel = UILabel()
  let priceLabel = UILabel()
  
  // MARK: - 모델
  
  var product: ProductItem? {
    didSet {
      imageView.image = UIImage(named: product?.image ?? "placeholder")
      nameLabel.text = product?.name ?? "-"
      priceLabel.text = "\(product?.price ?? "0")원"
    }
  }
  
  // MARK: - 초기화
  
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
      backgroundColor = AppColorType.background
    layer.cornerRadius = 8
    layer.borderWidth = 0.5
    layer.borderColor = UIColor.lightGray.cgColor
    clipsToBounds = true
    
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = 8
    imageView.clipsToBounds = true
    
    nameLabel.font = Font.title(size: 14)
    nameLabel.textAlignment = .center
    
    priceLabel.font = Font.title(size: 15)
    priceLabel.textColor = AppColorType.highlight
    priceLabel.textAlignment = .center
    
    let stack = UIStackView(arrangedSubviews: [imageView, nameLabel, priceLabel])
    stack.axis = .vertical
    stack.spacing = 6
    
    addSubview(stack)
    stack.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(8)
    }
    
    imageView.snp.makeConstraints {
      $0.height.equalToSuperview().multipliedBy(0.75)
    }
  }
}
