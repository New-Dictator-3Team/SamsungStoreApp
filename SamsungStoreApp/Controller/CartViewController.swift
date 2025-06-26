//
//  CartViewController.swift
//  SamsungStoreApp
//
//  Created by 서광용 on 6/26/25.

// MARK: Cart View

import SnapKit
import UIKit

final class CartViewController: UIViewController {
  private let tableContainerView = UIView()
  private let tableView = UITableView()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupTableView()
  }

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

  private func setupTableView() {
    tableView.dataSource = self // 몇 개의 셀을 만들지, 어떻게 생겼는지
    tableView.delegate = self // UI 이벤트 처리
    tableView.register(CartItemCell.self, forCellReuseIdentifier: "CartItemCell") // CartItemCell을 쓸 것임
  }

  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return 4
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // 등록해뒀던 "CartItemCell" 이름의 셀을 달라고 요청. (셀이 있으면 재사용, 없으면 만듦)
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as? CartItemCell else {
      return UITableViewCell()
    }
    return cell
  }
}

extension CartViewController: UITableViewDataSource {}
extension CartViewController: UITableViewDelegate {}
