//
//  CartItemCell.swift
//  SamsungStoreApp
//
//  Created by 서광용 on 6/26/25.

// MARK: CartItemCell

import SnapKit
import UIKit

// 셀 내부 이벤트를 CartViewController로 전달하기 위한 Delegate
protocol CartItemCellDelegate: AnyObject {
  func didTapDeleteButton(_ cell: CartItemCell)
  func cartItemCell(_ cell: CartItemCell, didChangeCount newCount: Int)
}

final class CartItemCell: UITableViewCell {
  private let itemLabel = UILabel()
  private let countLabel = UILabel()
  private let priceLabel = UILabel()

  private let minusButton = UIButton()
  private let plusButton = UIButton()
  private let deleteButton = UIButton()

  private let countContainerView = UIView()

  private var item: CartItem? // 내부 변경 x

  // cell.delegate = self 호출 안하면 nil이기 때문에 옵셔널
  weak var delegate: CartItemCellDelegate?

  // MARK: init

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none // 셀 선택 강조 안보이도록
    setupUI()
    setupLayout()
    setupActions()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - setupUI

  private func setupUI() {
    backgroundColor = AppColorType.background
    addSubviews()
    setupUIComponents()
  }

  // MARK: - addSubviews

  private func addSubviews() {
    for item in [itemLabel, countContainerView, priceLabel, deleteButton] {
      contentView.addSubview(item)
    }

    for item in [minusButton, countLabel, plusButton] {
      countContainerView.addSubview(item)
    }
  }

  // MARK: setupUIComponents

  private func setupUIComponents() {
    setupButtons()
    setupLabels()
    setupDeleteButtonColor()
  }

  private func setupButtons() {
    plusButton.configure(title: "+")
    deleteButton.configure(title: "X")
  }

  private func setupLabels() {
    itemLabel.configureLabel(font: Font.title(size: 14), color: AppColorType.secondary, alignment: .left)
    countLabel.configureLabel(font: Font.title(size: 14), color: AppColorType.secondary, alignment: .center)
    priceLabel.configureLabel(font: Font.text(size: 13), color: AppColorType.secondary, alignment: .right)
  }

  private func setupDeleteButtonColor() {
    deleteButton.setTitleColor(.red, for: .normal)
  }

  // MARK: setupLayout

  private func setupLayout() {
    setupItemLabelLayout()
    setupCountContainerViewLayout()
    setupMinusButtonLayout()
    setupCountLabelLayout()
    setupPlusButtonLayout()
    setupPriceLabelLayout()
    setupDeleteButtonLayout()
  }

  // itemLabel 제약조건
  private func setupItemLabelLayout() {
    itemLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(12)
      $0.trailing.equalTo(countContainerView.snp.leading)
      $0.centerY.equalToSuperview()
    }
  }

  // countContainerView 제약조건 (가운데 카운트 영역은 위치, 크기 고정)
  private func setupCountContainerViewLayout() {
    countContainerView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.centerX.equalToSuperview()

      // 가운데 위치 고정을 위해
      $0.width.greaterThanOrEqualTo(94).priority(.high) // 최소 36 + 22 + 36
      $0.width.lessThanOrEqualTo(110).priority(.required) // 최대 44 + 22 + 44
      $0.height.equalTo(44)
    }
  }

  // minusButton 제약조건
  private func setupMinusButtonLayout() {
    minusButton.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.centerY.equalToSuperview()
      $0.width.greaterThanOrEqualTo(36).priority(.high) // 최소 36
      $0.width.lessThanOrEqualTo(44).priority(.required) // 최대 44
    }
  }

  // countLabel 제약조건
  private func setupCountLabelLayout() {
    countLabel.snp.remakeConstraints {
      $0.leading.equalTo(minusButton.snp.trailing)
      $0.centerY.equalToSuperview()
      $0.trailing.equalTo(plusButton.snp.leading)
    }
    countLabel.setContentCompressionResistancePriority(.required, for: .horizontal) // 작아지지 않도록
  }

  // plusButton 제약조건
  private func setupPlusButtonLayout() {
    plusButton.snp.makeConstraints {
      $0.trailing.equalToSuperview()
      $0.centerY.equalToSuperview()
      $0.width.greaterThanOrEqualTo(36).priority(.high)
      $0.width.lessThanOrEqualTo(44).priority(.required)
    }
  }

  // priceLabel 제약조건
  private func setupPriceLabelLayout() {
    priceLabel.snp.makeConstraints {
      $0.leading.equalTo(countContainerView.snp.trailing)
      $0.trailing.equalTo(deleteButton.snp.leading)
      $0.centerY.equalToSuperview()
    }
  }

  // deleteButton 제약조건
  private func setupDeleteButtonLayout() {
    deleteButton.snp.makeConstraints {
      $0.trailing.equalToSuperview()
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(44)
    }
  }

  // MARK: Actions

  private func setupActions() {
    minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
    plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
  }

  // + 버튼 클릭 시 수량 증가 요청 (최대 25까지)
  @objc private func plusButtonTapped() {
    guard let item = item, item.count < 25 else { return }
    delegate?.cartItemCell(self, didChangeCount: item.count + 1)
  }

  // - 버튼 클릭 시 수량 감소 또는 삭제
  @objc private func minusButtonTapped() {
    guard let item = item else { return }
    if item.count <= 1 { // item.count가 1이하일 때 누르면 DeleteButton과 동일 (셀 삭제)
      delegate?.didTapDeleteButton(self)
      return
    }
    delegate?.cartItemCell(self, didChangeCount: item.count - 1)
  }

  // 삭제 버튼 클릭 시 삭제 요청
  @objc private func deleteButtonTapped() {
    delegate?.didTapDeleteButton(self) // CartItemCell에서 삭제 버튼이 눌림을 VC에 알리기 위해
  }

  // MARK: - configure

  // 전달받은 CartItem으로 셀 UI구성
  func configure(item: CartItem) {
    self.item = item
    itemLabel.text = item.name
    countLabel.text = "\(item.count)"
    priceLabel.text = "\(PriceFormatter.format(item.price * item.count)) 원"

    updateMinusButton(item.count)
    plusButton.setTitleColor(item.count >= 25 ? AppColorType.division : .systemBlue, for: .normal)
  }

  // 개수가 1개 이하라면 trash이미지로 변경
  private func updateMinusButton(_ count: Int) {
    minusButton.setTitle(nil, for: .normal)
    minusButton.setImage(nil, for: .normal)

    if count <= 1 {
      minusButton.setImage(UIImage(systemName: "trash"), for: .normal)
      minusButton.tintColor = .red
    } else {
      minusButton.configure(title: "−")
    }
  }
}

// MARK: - UIButton Method

private extension UIButton {
  func configure(title: String) {
    self.setTitle(title, for: .normal)
    self.setTitleColor(.systemBlue, for: .normal)
  }
}

// MARK: - UILabel Method

extension UILabel {
  func configureLabel(font: UIFont, color: UIColor, alignment: NSTextAlignment) {
    self.font = font
    self.textColor = color
    self.textAlignment = alignment
  }
}
