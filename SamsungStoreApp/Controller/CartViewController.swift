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

  // 총 금액
  var totalPrice: Int {
    return price * count
  }
}

final class CartViewController: UIViewController {
  private let tableContainerView = UIView()
  private let tableView = UITableView()

  private var cartItems: [CartItem] = [ // 더미 데이터
    CartItem(name: "갤럭시 S25", price: 1000000, count: 1),
    CartItem(name: "갤럭시 버즈", price: 1200000, count: 1)
  ]
//  private var cartItems: [CartItem] = []

  // MARK: viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    configureTableView()
  }

  // MARK: setup

  private func setupUI() {
    view.backgroundColor = .white

    tableContainerView.layer.cornerRadius = 12
    tableContainerView.layer.borderColor = UIColor.black.cgColor
    tableContainerView.layer.borderWidth = 1
    tableContainerView.clipsToBounds = true

    view.addSubview(tableContainerView)
    tableContainerView.addSubview(tableView)

    tableContainerView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview().inset(12)
      $0.height.equalTo(176)
    }

    tableView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }
  }

  // MARK: TableView Configuration

  private func configureTableView() {
    tableView.dataSource = self // 몇 개의 셀을 만들지, 어떻게 생겼는지
    tableView.delegate = self // UI 이벤트 처리
    tableView.register(CartItemCell.self, forCellReuseIdentifier: "CartItemCell") // TableView가 사용할 셀 클래스를 미리 등록(CartItemCell)
  }

  // 장바구니 추가 (정의만)
  func addItem(_ item: CartItem) {
    // 조건 만족하는 첫 번째를 찾음
    if let index = cartItems.firstIndex(where: { $0.name == item.name }) {
      cartItems[index].count += 1
      tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic) // 행만 reload
    } else { // 존재하지 않으면 추가하고 리로드
      cartItems.append(item)
      tableView.reloadData()
    }
  }

  // 장바구니 제거 (정의만)
  func removeItem(_ index: Int) {
    cartItems.remove(at: index)
    // index 번째 셀을 지움
    tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
  }
}

// MARK: Data Sourece

extension CartViewController: UITableViewDataSource {
  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return cartItems.count
  }

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

// MARK: Delegate

extension CartViewController: UITableViewDelegate, CartItemCellDelegate {
  func didTapDeleteButton(_ cell: CartItemCell) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    removeItem(indexPath.row)
  }
}
