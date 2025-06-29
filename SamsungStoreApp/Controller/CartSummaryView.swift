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

  // TODO: 아래 폰트나 색상 등 나중에 변경 예정. 임시로 값 줌
  private func setupItemCountLabel() {
    itemCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    itemCountLabel.textColor = .darkGray
  }

  private func setupTotalPriceLabel() {
    totalPriceLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    totalPriceLabel.textColor = UIColor.systemBlue // 색상 변경 예정
    totalPriceLabel.adjustsFontSizeToFitWidth = true
  }

  private func setupWonLabel() {
    wonLabel.text = "원"
    wonLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    wonLabel.textColor = .black
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
