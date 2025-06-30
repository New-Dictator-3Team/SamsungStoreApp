//
//  CartViewController.swift
//  SamsungStoreApp
//
//  Created by 서광용 on 6/26/25.

// MARK: Cart View

import SnapKit
import UIKit

final class CartView: UIView {
  private let tableContainerView = UIView()
  let tableView = UITableView()

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
    backgroundColor = .white

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

  private func configureTableView() {
    tableView.register(CartItemCell.self, forCellReuseIdentifier: "CartItemCell") // TableView가 사용할 셀 클래스를 미리 등록(CartItemCell)
  }

  func reload() {
    tableView.reloadData()
  }
}
