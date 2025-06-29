//
//  CartViewController.swift
//  SamsungStoreApp
//
//  Created by 서광용 on 6/26/25.

// MARK: Cart View

import SnapKit
import UIKit

struct CartItem {
  let name: String
  var price: Int
  var count: Int
}

final class CartViewController: UIViewController {
  private let tableContainerView = UIView()
  private let tableView = UITableView()

  private var cartItems: [CartItem] = []
  let summaryView = CartSummaryView() // CartSummaryView 인스턴스 생성

  // MARK: viewDidLoad

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupLayout()
    configureTableView()
    updateCartSummary()
  }

  // MARK: setupUI

  private func setupUI() {
    addSubviews()
    setupUIComponents()
  }

  // MARK: addSubviews

  private func addSubviews() {
    for item in [tableContainerView, summaryView] {
      view.addSubview(item)
    }

    tableContainerView.addSubview(tableView)
  }

  // MARK: setupUIComponents

  private func setupUIComponents() {
    view.backgroundColor = .white

    tableContainerView.layer.cornerRadius = 8
    tableContainerView.layer.borderColor = UIColor.lightGray.cgColor
    tableContainerView.layer.borderWidth = 0.5
    tableContainerView.clipsToBounds = true
  }

  // MARK: setupLayout

  private func setupLayout() {
    setupTableContainerViewLayout()
    setupTableViewLayout()
    setupsummaryViewLayout()
  }

  // tableContainerView 제약조건
  private func setupTableContainerViewLayout() {
    tableContainerView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview().inset(12)
      $0.height.equalTo(176)
    }
  }

  // tableView 제약조건
  private func setupTableViewLayout() {
    tableView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }
  }

  // summaryView 제약조건
  private func setupsummaryViewLayout() {
    summaryView.snp.makeConstraints {
      $0.top.equalTo(tableView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(80) // 높이 80 고정
    }
  }

  // MARK: - configureTableView

  // dataSource + delegate 설정 및 셀
  private func configureTableView() {
    tableView.dataSource = self // 몇 개의 셀을 만들지, 어떻게 생겼는지
    tableView.delegate = self // UI 이벤트 처리
    tableView.register(CartItemCell.self, forCellReuseIdentifier: "CartItemCell") // TableView가 사용할 셀 클래스를 미리 등록(CartItemCell)
  }

  // 장바구니에 새로운 아이템 추가, 이미 있다면 수량 증가
  func addItem(_ item: CartItem) {
    // 조건 만족하는 첫 번째를 찾음
    if let index = cartItems.firstIndex(where: { $0.name == item.name }) {
      cartItems[index].count += 1
      tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic) // 행만 reload
      updateCartSummary()
    } else { // 존재하지 않으면 추가하고 리로드
      cartItems.insert(item, at: 0) // 리스트 맨 앞에 추가
      tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
      updateCartSummary()
    }
  }

  // 지정된 인덱스의 아이템을 장바구니에서 제거
  func removeItem(_ index: Int) {
    cartItems.remove(at: index)
    // index 번째 셀을 지움
    tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    updateCartSummary()
  }

  // 총 금액, 개수 업데이트
  private func updateCartSummary() {
    let totalCount = cartItems.reduce(0) { $0 + $1.count }
    let totalPrice = cartItems.reduce(0) { $0 + ($1.price * $1.count) }
    summaryView.configure(itemCount: totalCount, totalPrice: totalPrice)
  }
}

// MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {
  // 장바구니의 개수
  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return cartItems.count
  }

  // cell 구성하고 데이터를 cell에 전달
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // 등록해뒀던 "CartItemCell" 이름의 셀을 달라고 요청. (셀이 있으면 재사용, 없으면 만듦)
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as? CartItemCell else {
      return UITableViewCell()
    }
    cell.delegate = self // 위임받음
    let item = cartItems[indexPath.row]
    cell.configure(item: item)
    return cell
  }
}

// MARK: - UITableViewDelegate, CartItemCellDelegate

// Delegate(셀 내부 발생 이벤트)
extension CartViewController: UITableViewDelegate, CartItemCellDelegate {
  // 셀에서 삭제 버튼이 눌렸을 때 아이템 제거
  func didTapDeleteButton(_ cell: CartItemCell) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    removeItem(indexPath.row)
  }

  // 셀에서 수량이 변경될 때 데이터를 수정하고 셀 갱신
  func cartItemCell(_ cell: CartItemCell, didChangeCount newCount: Int) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    cartItems[indexPath.row].count = newCount
    tableView.reloadRows(at: [indexPath], with: .automatic)
    updateCartSummary()
  }
}

// MARK: - ProductPageViewDelegate

// Delegate(상품 목록 페이지에서 발생 이벤트)
extension CartViewController: ProductPageViewDelegate {
  // 선택된 상품(Product)을 CartItem으로 변환해서 장바구니 추가
  func productPageView(_ view: ProductPageView, didSelect product: ProductItem) {
    if let index = cartItems.firstIndex(where: { $0.name == product.name }) {
      guard cartItems[index].count < 25 else { return }
      cartItems[index].count += 1
      tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
      updateCartSummary()
    } else {
      let item = CartItem(name: product.name, price: PriceFormatter.format(product.price), count: 1)
      addItem(item)
      updateCartSummary()
    }
  }

  // 카테고리 변경 (사용 x. 프로토콜 요구사항이라 구현만)
  func productPageView(_ view: ProductPageView, didUpdateCategory category: String) {}
}
