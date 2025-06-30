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
    scrollProductCartView.productPageView.configure(with: selectedItems)
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
      // 장바구니 초기화
      self.cartItems.removeAll()
      self.updateCartView()
    }
  }
  
  // 주문 결제
  func didTapPayButton() {
    showAlert(title: "주문 결제", message: "해당 상품을 결제하시겠습니까?") {
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
    
    alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "네", style: .destructive, handler: { _ in
      onConfirm()
    }))
    
    present(alert, animated: true)
  }
  
  // 결제 완료 안내
  private func showSuccessAlert() {
    let successAlert = UIAlertController(
      title: "결제 완료",
      message: "주문하신 내역이 결제 완료되었습니다.",
      preferredStyle: .alert
    )
    
    successAlert.addAction(UIAlertAction(title: "확인", style: .default))
    
    present(successAlert, animated: true)
  }
}
