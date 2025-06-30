//
//  BottomView.swift
//  SamsungStoreApp
//
//  Created by estelle on 6/27/25.
//

import UIKit
import SnapKit

protocol BottomViewDelegate: AnyObject {
  func didTapClearButton()
  func didTapPayButton()
}

/// 하단 결제/취소 버튼 뷰
class BottomView: UIView {
  weak var delegate: BottomViewDelegate?
  
  // 버튼 생성
  private let clearButton: BottomButton = .init(title: "전체 취소", type: .clear, fontSize: 18)
  private let payButton: BottomButton = .init(title: "결제하기", type: .pay, fontSize: 18)
  
  /// 버튼들을 수평 정렬할 스택뷰
  private lazy var bottomButtonStack: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [clearButton, payButton])
    stackView.axis = .horizontal
    stackView.spacing = 24
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  // MARK: - Initializer
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI 구성
  
  private func setupUI() {
    addSubview(bottomButtonStack)
    bottomButtonStack.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(24)
      $0.top.bottom.equalToSuperview()
    }
    
    updateButtonsEnabled(false)
    clearButton.setAction(self, action: #selector(clearButtonTapped))
    payButton.setAction(self, action: #selector(payButtonTapped))
  }
  
  // MARK: - 버튼 액션 핸들러
  @objc private func clearButtonTapped() {
    delegate?.didTapClearButton()
  }
  
  @objc private func payButtonTapped() {
    delegate?.didTapPayButton()
  }
  
  // MARK: - 버튼 활성화/비활성화 제어
  func updateButtonsEnabled(_ isEnabled: Bool) {
    [clearButton, payButton].forEach {
      $0.isEnabled = isEnabled
      $0.alpha = isEnabled ? 1.0 : 0.3
    }
  }
}
