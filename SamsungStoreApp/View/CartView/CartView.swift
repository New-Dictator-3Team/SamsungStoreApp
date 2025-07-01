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
  let emptyLabel = UILabel()
  
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
    emptyLabel.text = "empty_shopping_cart".localized
    emptyLabel.textAlignment = .center
    emptyLabel.textColor = .secondaryLabel
    emptyLabel.font = Font.title(size: 16)
    
    tableContainerView.layer.cornerRadius = 8
    tableContainerView.layer.borderColor = UIColor.lightGray.cgColor
    tableContainerView.layer.borderWidth = 0.5
    tableContainerView.clipsToBounds = true
    
    tableView.backgroundColor = AppColorType.background
  }
  
  // MARK: setupLayout
  
  private func setupLayout() {
    setupTableContainerViewLayout()
    setupTableViewLayout()
  }
  
  // tableContainerView 제약조건
  private func setupTableContainerViewLayout() {
    tableContainerView.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview().inset(16)
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
    tableView.isScrollEnabled = false
  }
  
  func reload() {
    tableView.reloadData()
  }
  
  func updateEmptyLabel(isEmpty: Bool) { // 장바구니 비어 있을 경우에 안내 문구 표시
    tableView.backgroundView = isEmpty ? emptyLabel : nil
  }
  
  // tableContainerView의 높이 업데이트
  func updateHeight(_ height: CGFloat) { // 176
    tableContainerView.snp.remakeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.height.equalTo(height)
    }
  }
}
