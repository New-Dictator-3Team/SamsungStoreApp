//
//  CartViewController.swift
//  SamsungStoreApp
//
//  Created by 서광용 on 6/26/25.

// MARK: Cart View

import SnapKit
import UIKit

final class CartViewController: UIViewController {
  // MARK: Properties

  private let tableContainerView = UIView()
  private let tableView = UITableView()

  private let cartItems: [CartItem] = [ // 더미 데이터
    CartItem(name: "갤럭시 S25", price: "1,000,000"),
    CartItem(name: "갤럭시 버즈", price: "1,200,000"),
    CartItem(name: "갤럭시 버즈 2", price: "2,000,000"),
    CartItem(name: "갤럭시 워치", price: "600,000"),
    CartItem(name: "갤럭시 플립", price: "3,000,000"),
    CartItem(name: "갤럭시 폴드", price: "1,500,000"),
  ]

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
    tableView.register(CartItemCell.self, forCellReuseIdentifier: "CartItemCell") // CartItemCell을 쓸 것임
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

    let item = cartItems[indexPath.row]
    cell.configure(itemName: item.name, price: item.price)
    return cell
  }
}

// MARK: Delegate

extension CartViewController: UITableViewDelegate {}

struct CartItem {
  let name: String
  let price: String
}
