//
//  MenuCollectionViewCell.swift
//  SamsungStoreApp
//
//  Created by 김우성 on 6/26/25.
//

import UIKit
import SnapKit

final class MenuCollectionViewCell: UICollectionViewCell {
  static let reuseIdentifier = "MenuCollectionViewCell"
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = .systemFont(ofSize: 16, weight: .medium)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    contentView.backgroundColor = .white
    contentView.addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
  
  func configure(with item: MenuItem) {
    titleLabel.text = item.title
  }
}
