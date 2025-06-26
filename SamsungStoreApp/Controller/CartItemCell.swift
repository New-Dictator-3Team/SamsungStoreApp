//
//  CartItemCell.swift
//  SamsungStoreApp
//
//  Created by 서광용 on 6/26/25.

// MARK: Custom Cell View

import SnapKit
import UIKit

final class CartItemCell: UITableViewCell {
  private let stackView = UIStackView()
  private let countStackView = UIStackView()
  
  private let itemLabel = UILabel()
  private let minusButton = UIButton()
  private let countLabel = UILabel()
  private let plusButton = UIButton()
  private let priceLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none // 셀 선택 강조 안보이도록
    setupUI()
    setupLayout()
  }

  @available(*, unavailable) // 넌 뭔데 계속 생기니?
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: setup

  private func setupUI() {
    configureStackView()
    configureCountStackView()
    configureComponents()
  }
  
  // MARK: stackView

  private func configureStackView() {
    contentView.addSubview(stackView)
    stackView.axis = .horizontal
    stackView.spacing = 12
    stackView.distribution = .fill
    stackView.alignment = .center
    
    for item in [itemLabel, countStackView, priceLabel] {
      stackView.addArrangedSubview(item)
    }
  }
  
  private func configureCountStackView() {
    countStackView.axis = .horizontal
    for item in [plusButton, countLabel, minusButton] {
      countStackView.addArrangedSubview(item)
    }
  }
  
  // MARK: components

  private func configureComponents() {
    itemLabel.configure(text: "갤럭시 S25")
    countLabel.configure(text: "1")
    priceLabel.configure(text: "10,000원")

    minusButton.configure(title: "−")
    plusButton.configure(title: "+")
    
    itemLabel.textAlignment = .left
    priceLabel.textAlignment = .right
  }

  private func setupLayout() {
    stackView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(12)
    }
    
    minusButton.snp.makeConstraints {
      $0.width.height.equalTo(44)
    }
    
    plusButton.snp.makeConstraints {
      $0.width.height.equalTo(44)
    }
    
    itemLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    priceLabel.setContentHuggingPriority(.required, for: .horizontal)
    countLabel.textAlignment = .center
    
    countLabel.snp.makeConstraints {
      $0.width.equalTo(32)
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
