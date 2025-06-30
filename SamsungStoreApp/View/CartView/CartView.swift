//
//  CartViewController.swift
//  SamsungStoreApp
//
//  Created by 서광용 on 6/26/25.

// MARK: Cart View

import SnapKit
import UIKit

protocol CartViewDelegate: AnyObject {
  func cartView(_ cartView: CartView, didTapDeleteAt index: Int)
  func cartView(_ cartView: CartView, didChangeCountAt index: Int, to newCount: Int)
}

final class CartView: UIView {
  weak var delegate: CartViewDelegate?
  private var displayedItems: [CartItem] = []

  private let tableContainerView = UIView()
  private let tableView = UITableView()

  // MARK: viewDidLoad

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupLayout()
    configureTableView()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: setupUI

  private func setupUI() {
    addSubviews()
    setupUIComponents()
  }

  // MARK: addSubviews

  private func addSubviews() {
    addSubview(tableContainerView)
    tableContainerView.addSubview(tableView)
  }

  // MARK: setupUIComponents

  private func setupUIComponents() {
      backgroundColor = AppColorType.background

    tableContainerView.layer.cornerRadius = 8
    tableContainerView.layer.borderColor = UIColor.lightGray.cgColor
    tableContainerView.layer.borderWidth = 0.5
    tableContainerView.clipsToBounds = true
  }

  // MARK: setupLayout

  private func setupLayout() {
    setupTableContainerViewLayout()
    setupTableViewLayout()
  }

  // tableContainerView 제약조건
  private func setupTableContainerViewLayout() {
    tableContainerView.snp.makeConstraints {
      $0.top.bottom.equalTo(safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview().inset(12)
//      $0.height.equalTo(150)
    }
  }

  // tableView 제약조건
  private func setupTableViewLayout() {
    tableView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }
  }

  // MARK: - configureTableView

  // dataSource + delegate 설정 및 셀
  private func configureTableView() {
    tableView.dataSource = self // 몇 개의 셀을 만들지, 어떻게 생겼는지
    tableView.delegate = self // UI 이벤트 처리
    tableView.register(CartItemCell.self, forCellReuseIdentifier: "CartItemCell") // TableView가 사용할 셀 클래스를 미리 등록(CartItemCell)
  }

  func reload(with items: [CartItem], totalCount: Int, totalPrice: Int) {
    self.displayedItems = items
    tableView.reloadData()
  }
}

// MARK: - UITableViewDataSource

extension CartView: UITableViewDataSource {
  // 장바구니의 개수
  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return displayedItems.count
  }

  // cell 구성하고 데이터를 cell에 전달
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // 등록해뒀던 "CartItemCell" 이름의 셀을 달라고 요청. (셀이 있으면 재사용, 없으면 만듦)
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as? CartItemCell else {
      return UITableViewCell()
    }
    cell.delegate = self // 위임받음
    let item = displayedItems[indexPath.row]
    cell.configure(item: item)
    return cell
  }
}

// MARK: - UITableViewDelegate, CartItemCellDelegate

// Delegate(셀 내부 발생 이벤트)
extension CartView: UITableViewDelegate, CartItemCellDelegate {
  // 셀에서 삭제 버튼이 눌렸을 때, 델리게이트에 알림
  func didTapDeleteButton(_ cell: CartItemCell) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    delegate?.cartView(self, didTapDeleteAt: indexPath.row)
  }

  // 셀에서 수량이 변경될 때, 델리게이트에 알림
  func cartItemCell(_ cell: CartItemCell, didChangeCount newCount: Int) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    delegate?.cartView(self, didChangeCountAt: indexPath.row, to: newCount)
  }
}
