//
//  CartItemCell.swift
//  SamsungStoreApp
//
//  Created by 서광용 on 6/26/25.

// MARK: Custom Cell View

import SnapKit
import UIKit

final class CartItemCell: UITableViewCell {
  private let containerView = UIView()
  private let stackView = UIStackView()
  
  private let itemLabel = UILabel()
  private let minusButton = UIButton()
  private let countLabel = UILabel()
  private let plusButton = UIButton()
  private let priceLabel = UILabel()
  
  private var count: Int = 1

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none // cell 누를때 효과 안나오도록
    setupUI()
    setupLayout()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: setup
  private func setupUI() {
    contentView.addSubview(containerView)
    containerView.backgroundColor = .white
    containerView.clipsToBounds = true
    
    configureStackView()
    configureComponents()
  }
  
  // MARK: stackView
  private func configureStackView() {
    containerView.addSubview(stackView)
    stackView.axis = .horizontal
    stackView.spacing = 12
    stackView.distribution = .fill
    stackView.alignment = .center
    
    [itemLabel, minusButton, countLabel, plusButton, priceLabel].forEach {
      stackView.addArrangedSubview($0)
    }
  }
  
  // MARK: components
  private func configureComponents() {
    itemLabel.configure(text: "제품명")
    countLabel.configure(text: "1")
    priceLabel.configure(text: "10,000원")

    minusButton.configure(title: "−")
    plusButton.configure(title: "+")
    
    itemLabel.textAlignment = .left
    priceLabel.textAlignment = .right
    
//    minusButton.setContentHuggingPriority(.required, for: .horizontal)
//    minusButton.setContentCompressionResistancePriority(.required, for: .horizontal)
//    plusButton.setContentHuggingPriority(.required, for: .horizontal)
//    plusButton.setContentCompressionResistancePriority(.required, for: .horizontal)
//    
//    countLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//    countLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
//    
//    itemLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
//    itemLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//    
//    priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//    priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
  }

  private func setupLayout() {
    containerView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(24)
    }
    
    stackView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }
    
    minusButton.snp.makeConstraints {
      $0.width.height.equalTo(44)
    }
    
    plusButton.snp.makeConstraints {
      $0.width.height.equalTo(44)
    }
  }

}

// MARK: - UILabel & UIButton 설정 Extension
private extension UILabel {
  func configure(text: String) {
    self.text = text
  }
}

private extension UIButton {
  func configure(title: String) {
    self.setTitle(title, for: .normal)
    self.setTitleColor(.systemBlue, for: .normal)
  }
}
