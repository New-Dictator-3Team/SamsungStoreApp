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

  private let countContainerView = UIView() // 스택 뷰에서 변경

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
    addSubviews()
    setupUIComponents()
  }
  
  // MARK: - addSubviews
  private func addSubviews() {
    for item in [itemLabel, countContainerView, priceLabel, deleteButton] {
      contentView.addSubview(item)
    }

    for item in [plusButton, countLabel, minusButton] {
      countContainerView.addSubview(item)
    }
  }
  
  // MARK: setupUIComponents
  private func setupUIComponents() {
    minusButton.configure(title: "−")
    plusButton.configure(title: "+")
    deleteButton.configure(title: "X")
    deleteButton.setTitleColor(.red, for: .normal)

    itemLabel.textAlignment = .left
    priceLabel.textAlignment = .right
    countLabel.textAlignment = .center
  }

  // MARK: setupLayout
  private func setupLayout() {
    setupItemLabelLayout()
    setupCountContainerViewLayout()
    setupPlusButtonLayout()
    setupCountLabelLayout()
    setupDeleteButtonLayout()
    setupPriceLabelLayout()
    setupMinusButtonLayout()
  }
  
  // itemLabel 제약조건
  private func setupItemLabelLayout() {
    itemLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(12)
      $0.centerY.equalToSuperview()
      $0.width.equalTo(190)
    }
  }
  
  // countContainerView 제약조건
  private func setupCountContainerViewLayout() {
    countContainerView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.width.equalTo(112) // 44 + 24 + 44
      $0.leading.equalTo(itemLabel.snp.trailing)
      $0.trailing.equalTo(priceLabel.snp.leading)
    }
  }

  // plusButton 제약조건
  private func setupPlusButtonLayout() {
    plusButton.snp.makeConstraints {
      $0.leading.top.bottom.equalToSuperview()
      $0.width.height.equalTo(44)
    }
  }

  // countLabel 제약조건
  private func setupCountLabelLayout() {
    countLabel.snp.remakeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(plusButton.snp.trailing)
      $0.trailing.equalTo(minusButton.snp.leading)
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

  // priceLabel 제약조건
  private func setupPriceLabelLayout() {
    priceLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalTo(deleteButton.snp.leading)
      $0.width.equalTo(110)
    }
  }

  // minusButton 제약조건
  private func setupMinusButtonLayout() {
    minusButton.snp.makeConstraints {
      $0.trailing.top.bottom.equalToSuperview()
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
  
  // 1000000의 정수 값을 -> "1,000,000"형식의 문자열 변경
  private func formatPrice(_ price: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal // 천 단위마다 쉼표를 넣는 형식
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
  }

  // MARK: - configure
  // 전달받은 CartItem으로 셀 UI구성
  func configure(item: CartItem) {
    self.item = item
    itemLabel.text = item.name
    countLabel.text = "\(item.count)"
    priceLabel.text = "\(formatPrice(item.price * item.count)) 원"
  }
}

// MARK: - UIButton Method
private extension UIButton {
  func configure(title: String) {
    self.setTitle(title, for: .normal)
    self.setTitleColor(.systemBlue, for: .normal)
  }
}
