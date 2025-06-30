//
//  BottomView.swift
//  SamsungStoreApp
//
//  Created by estelle on 6/27/25.
//

import UIKit

/// 하단 결제/취소 버튼 뷰
class BottomView: UIView {
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
  }
}
