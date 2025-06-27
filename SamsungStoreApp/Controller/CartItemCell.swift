//
//  CartItemCell.swift
//  SamsungStoreApp
//
//  Created by 서광용 on 6/26/25.

// MARK: Custom Cell View

import SnapKit
import UIKit

final class CartItemCell: UITableViewCell {
  private let itemLabel = UILabel()
  private let countLabel = UILabel()
  private let priceLabel = UILabel()

  private let minusButton = UIButton()
  private let plusButton = UIButton()
  private let deleteButton = UIButton()

  private let countContainerView = UIView() // 스택 뷰에서 변경

  private var count: Int = 1 // count

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
    configureComponents()
    addSubviews()
  }

  private func addSubviews() {
    for item in [itemLabel, countContainerView, priceLabel, deleteButton] {
      contentView.addSubview(item)
    }

    for item in [plusButton, countLabel, minusButton] {
      countContainerView.addSubview(item)
    }
  }

  // MARK: components

  private func configureComponents() {
    minusButton.configure(title: "−")
    plusButton.configure(title: "+")
    deleteButton.configure(title: "X")
    deleteButton.setTitleColor(.red, for: .normal)

    itemLabel.textAlignment = .left
    priceLabel.textAlignment = .right
    countLabel.textAlignment = .center
  }

  private func setupLayout() {
    itemLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(12)
      $0.centerY.equalToSuperview()
      $0.width.equalTo(200)
    }

    deleteButton.snp.makeConstraints {
      $0.trailing.equalToSuperview()
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(44)
    }

    priceLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalTo(deleteButton.snp.leading)
      $0.width.equalTo(100)
    }

    countContainerView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.width.equalTo(112) // 44 + 24 + 44
      $0.leading.equalTo(itemLabel.snp.trailing)
      $0.trailing.equalTo(priceLabel.snp.leading)
    }

    plusButton.snp.makeConstraints {
      $0.leading.top.bottom.equalToSuperview()
      $0.width.height.equalTo(44)
    }

    countLabel.snp.remakeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(plusButton.snp.trailing)
      $0.trailing.equalTo(minusButton.snp.leading)
    }

    minusButton.snp.makeConstraints {
      $0.trailing.top.bottom.equalToSuperview()
      $0.width.height.equalTo(44)
    }

    setupPriorities()
    setupActions()
  }

  private func setupPriorities() {
    // 우선순위
    itemLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    itemLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

    countContainerView.setContentHuggingPriority(.required, for: .horizontal)
    countContainerView.setContentCompressionResistancePriority(.required, for: .horizontal)

    priceLabel.textAlignment = .right
    priceLabel.setContentHuggingPriority(.required, for: .horizontal)
    priceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
  }

  private func setupActions() {
    minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
    plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
  }

  // 버튼 누를때 액션
  @objc private func minusButtonTapped() {
    guard count > 1 else { return } // 1개 까지만
    count -= 1
    countLabel.text = "\(count)"
  }

  @objc private func plusButtonTapped() {
    guard count < 25 else { return } // count 최대 개수 25개
    count += 1
    countLabel.text = "\(count)"
  }

  // 전달받은 값으로 셀 구성
  func configure(itemName: String, price: String) {
    itemLabel.text = itemName
    priceLabel.text = "\(price)원"
    countLabel.text = "1"
  }
}

// MARK: - UIButton 설정 Extension

private extension UIButton {
  func configure(title: String) {
    self.setTitle(title, for: .normal)
    self.setTitleColor(.systemBlue, for: .normal)
  }
}
