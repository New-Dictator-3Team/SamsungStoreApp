//
//  CartSummaryView.swift
//  SamsungStoreApp
//
//  Created by 서광용 on 6/29/25.
//

import SnapKit
import UIKit

final class CartSummaryView: UIView {
  private let itemCountLabel = UILabel() // 총 개수
  private let totalPriceLabel = UILabel() // 금액
  private let wonLabel = UILabel() // 원

  // MARK: - Initializer

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupLayout()
    configure(itemCount: 0, totalPrice: 0) // 초기 값
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: setupUI

  private func setupUI() {
    backgroundColor = .white
    addSubviews()
    setupUIComponents()
    setupLayout()
  }

  // MARK: addSubviews

  private func addSubviews() {
    addSubview(itemCountLabel)
    addSubview(totalPriceLabel)
    addSubview(wonLabel)
  }

  // MARK: setupUIComponents

  private func setupUIComponents() {
    setupItemCountLabel()
    setupTotalPriceLabel()
    setupWonLabel()
  }

  private func setupItemCountLabel() {
    itemCountLabel.configureLabel(font: Font.text(size: 12), colorHex: "#4A4A4A", alignment: .right)
  }

  private func setupTotalPriceLabel() {
    totalPriceLabel.configureLabel(font: Font.title(size: 24), colorHex: "#2189FF", alignment: .right)
    totalPriceLabel.adjustsFontSizeToFitWidth = true
  }

  private func setupWonLabel() {
    wonLabel.text = "원"
    wonLabel.configureLabel(font: Font.title(size: 16), colorHex: "#000000", alignment: .right)
  }

  // MARK: setupLayout

  private func setupLayout() {
    setupItemCountLabelLayout()
    setupTotalPriceLabelLayout()
    setupWonLabelLayout()
  }

  // itemCountLabel 제약조건
  private func setupItemCountLabelLayout() {
    itemCountLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(8)
      make.trailing.equalToSuperview().inset(12)
    }
  }

  // totalPriceLabel 제약조건
  private func setupTotalPriceLabelLayout() {
    totalPriceLabel.snp.makeConstraints { make in
      make.top.equalTo(itemCountLabel.snp.bottom).offset(4)
      make.trailing.equalTo(wonLabel.snp.leading).offset(-4)
    }
  }

  // wonLabel 제약조건
  private func setupWonLabelLayout() {
    wonLabel.snp.makeConstraints { make in
      make.centerY.equalTo(totalPriceLabel)
      make.trailing.equalToSuperview().inset(12)
    }
  }

  // MARK: - Configuration

  func configure(itemCount: Int, totalPrice: Int) {
    itemCountLabel.text = "총 \(itemCount)개"
    totalPriceLabel.text = PriceFormatter.format(totalPrice)
  }
}
