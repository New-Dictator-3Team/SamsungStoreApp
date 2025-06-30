//
//  ViewController+Delegate.swift
//  SamsungStoreApp
//
//  Created by 서광용 on 6/30/25.
//

import UIKit

// MARK: - 델리게이트

extension ViewController: CategoryTabViewDelegate {
  func didTapCategoryButton(selectedCategoryIndex: Int) {
    let selectedItems = categories[selectedCategoryIndex].items
    productPageView.configure(with: selectedItems)
  }
}

extension ViewController: ProductPageViewDelegate {
  func productPageView(_ view: ProductPageView, didSelect product: ProductItem) {
    if let index = cartItems.firstIndex(where: { $0.name == product.name }) {
      guard cartItems[index].count < 25 else { return }
      cartItems[index].count += 1
    } else {
      let item = CartItem(name: product.name, price: PriceFormatter.format(product.price), count: 1)
      cartItems.insert(item, at: 0)
    }
    updateCartView()
  }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
  // 장바구니의 개수
  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return cartItems.count
  }

  // cell 구성하고 데이터를 cell에 전달
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // 등록해뒀던 "CartItemCell" 이름의 셀을 달라고 요청. (셀이 있으면 재사용, 없으면 만듦)
    guard let cell = cartView.tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as? CartItemCell else {
      return UITableViewCell()
    }
    cell.delegate = self
    let item = cartItems[indexPath.row]
    cell.configure(item: item)
    return cell
  }
}

// MARK: - UITableViewDelegate, CartItemCellDelegate

// Delegate(셀 내부 발생 이벤트)
extension ViewController: UITableViewDelegate, CartItemCellDelegate {
  // 셀에서 삭제 버튼이 눌렸을 때, 델리게이트에 알림
  func didTapDeleteButton(_ cell: CartItemCell) {
    guard let indexPath = cartView.tableView.indexPath(for: cell) else { return }
    cartItems.remove(at: indexPath.row)
    updateCartView()
  }

  // 셀에서 수량이 변경될 때, 델리게이트에 알림
  func cartItemCell(_ cell: CartItemCell, didChangeCount newCount: Int) {
    guard let indexPath = cartView.tableView.indexPath(for: cell) else { return }
    cartItems[indexPath.row].count = newCount
    updateCartView()
  }
}
