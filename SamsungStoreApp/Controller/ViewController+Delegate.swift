//
//  ViewController+Delegate.swift
//  SamsungStoreApp
//
//  Created by 서광용 on 6/30/25.
//

import UIKit

// MARK: - CategoryTabViewDelegate

extension ViewController: CategoryTabViewDelegate {
  func didTapCategoryButton(selectedCategoryIndex: Int) {
    let selectedItems = categories[selectedCategoryIndex].items
    scrollProductCartView.productPageView.configure(with: selectedItems)
  }
}

// MARK: - ProductPageViewDelegate

extension ViewController: ProductPageViewDelegate {
  func productPageView(_: ProductPageView, didSelect product: ProductItem) {
    if let index = cartItems.firstIndex(where: { $0.name == product.localizedName }) {
      guard cartItems[index].count < 25 else { return }
      cartItems[index].count += 1
    } else {
      let item = CartItem(name: product.localizedName, price: PriceFormatter.format(product.price), count: 1)
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
  func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // 등록해뒀던 "CartItemCell" 이름의 셀을 달라고 요청. (셀이 있으면 재사용, 없으면 만듦)
    guard let cell = scrollProductCartView.cartView.tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as? CartItemCell else {
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
    guard let indexPath = scrollProductCartView.cartView.tableView.indexPath(for: cell) else { return }
    cartItems.remove(at: indexPath.row)
    updateCartView()
  }

  // 셀에서 수량이 변경될 때, 델리게이트에 알림
  func cartItemCell(_ cell: CartItemCell, didChangeCount newCount: Int) {
    guard let indexPath = scrollProductCartView.cartView.tableView.indexPath(for: cell) else { return }
    cartItems[indexPath.row].count = newCount
    updateCartView()
  }
}

// MARK: - BottomViewDelegate

extension ViewController: BottomViewDelegate {
  // 주문 전체 취소
  func didTapClearButton() {
    showAlert(title: "cancel_order".localized, message: "cancel_message".localized) {
      // 장바구니 초기화
      self.cartItems.removeAll()
      self.updateCartView()
    }
  }

  // 주문 결제
  func didTapPayButton() {
    showAlert(title: "order".localized, message: "order_message".localized) {
      // 장바구니 초기화, 카테고리 첫번째로 이동
      self.cartItems.removeAll()
      self.updateCartView()

      self.categoryTabView.updateButtonState(index: 0)
      let selectedItems = self.categories[0].items
      self.scrollProductCartView.productPageView.configure(with: selectedItems)

      self.showSuccessAlert()
    }
  }

  private func showAlert(title: String, message: String, onConfirm: @escaping () -> Void) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "no".localized, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "yes".localized, style: .destructive, handler: { _ in
      onConfirm()
    }))

    present(alert, animated: true)
  }

  // 결제 완료 안내
  private func showSuccessAlert() {
    let successAlert = UIAlertController(
      title: "completed".localized,
      message: "completed_message".localized,
      preferredStyle: .alert
    )

    successAlert.addAction(UIAlertAction(title: "ok".localized, style: .default))

    present(successAlert, animated: true)
  }
}
