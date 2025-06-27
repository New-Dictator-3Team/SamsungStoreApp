

//
//  CartItemCell.swift
//  SamsungStoreApp
//
//  Created by 서광용 on 6/26/25.

// MARK: Custom Cell View

import SnapKit
import UIKit

protocol CartItemCellDelegate: AnyObject {
  func didTapDeleteButton(_ cell: CartItemCell)
}

final class CartItemCell: UITableViewCell {
  private let itemLabel = UILabel()
  private let countLabel = UILabel()
  private let priceLabel = UILabel()

  private let minusButton = UIButton()
  private let plusButton = UIButton()
  private let deleteButton = UIButton()

  private let countContainerView = UIView() // 스택 뷰에서 변경

  private var unitPrice: Int = 0 // 제품 1개의 가격
  private var count: Int = 1 // 현재 셀의 수량 (기본값: 1)
  
  // cell.delegate = self 호출 안하면 nil이기 때문에 옵셔널
  weak var delegate: CartItemCellDelegate?

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

  // MARK: subviews
  
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

    minusButton.snp.makeConstraints {
      $0.trailing.top.bottom.equalToSuperview()
      $0.width.height.equalTo(44)
    }

    setupActions()
  }

  private func setupActions() {
    minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
    plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
  }
  
  // 1000000 -> "1,000,000" 형식 변경
  private func formatPrice(_ price: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal // 천 단위마다 쉼표를 넣는 형식
    return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
  }

  // 버튼 누를때 액션
  
  @objc private func plusButtonTapped() {
    guard count < 25 else { return } // count 최대 개수 25개
    count += 1
    countLabel.text = "\(count)"
    priceLabel.text = "\(formatPrice(unitPrice * count)) 원"
  }
  
  
  @objc private func minusButtonTapped() {
    guard count > 1 else { return } // 1개 까지만
    count -= 1
    countLabel.text = "\(count)"
    priceLabel.text = "\(formatPrice(unitPrice * count)) 원"
  }
  
  @objc private func deleteButtonTapped() {
    delegate?.didTapDeleteButton(self) // CartItemCell에서 삭제 버튼이 눌림을 VC에 알리기 위해
  }

  // 전달받은 값으로 셀 구성
  func configure(item: CartItem) {
    itemLabel.text = item.name
    countLabel.text = "\(item.count)"
    priceLabel.text = item.priceText
    unitPrice = item.price
    count = item.count
  }
}

// MARK: - UIButton 설정 Extension

private extension UIButton {
  func configure(title: String) {
    self.setTitle(title, for: .normal)
    self.setTitleColor(.systemBlue, for: .normal)
  }
}
