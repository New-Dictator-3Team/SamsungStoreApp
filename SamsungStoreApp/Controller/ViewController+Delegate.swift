//
//  ViewController+Delegate.swift
//  SamsungStoreApp
//
//  Created by 서광용 on 6/30/25.
//

import UIKit

// MARK: - 델리게이트

extension ViewController: CategoryTabViewDelegate, ProductPageViewDelegate {
  func didTapCategoryButton(selectedCategoryIndex: Int) {
    let selectedItems = categories[selectedCategoryIndex].items
    productPageView.configure(with: selectedItems)
  }
  
  func productPageView(_ view: ProductPageView, didSelect product: ProductItem) {
    if let index = cartItems.firstIndex(where: { $0.name == product.name }) {
      guard cartItems[index].count < 25 else { return }
      cartItems[index].count += 1
      updateCartView()
    } else {
      let item = CartItem(name: product.name, price: PriceFormatter.format(product.price), count: 1)
      cartItems.insert(item, at: 0)
      updateCartView()
    }
  }
}

extension ViewController: CartViewDelegate, BottomViewDelegate {
  func cartView(_ cartView: CartView, didTapDeleteAt index: Int) {
    cartItems.remove(at: index)
    updateCartView()
  }
  
  func cartView(_ cartView: CartView, didChangeCountAt index: Int, to newCount: Int) {
    cartItems[index].count = newCount
    updateCartView()
  }
  
  // 주문 전체 취소
  func didTapClearButton() {
    showAlert(title: "주문 취소", message: "주문 내역을 모두 삭제하시겠습니까?") {
      self.cartItems.removeAll()
      self.updateCartView()
    }
  }
  
  func didTapPayButton() {
    
  }
  
  private func showAlert(title: String, message: String, onConfirm: @escaping () -> Void) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "네", style: .destructive, handler: { _ in
      onConfirm()
    }))
    
    present(alert, animated: true)
  }
}
