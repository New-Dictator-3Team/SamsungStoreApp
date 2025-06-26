//
//  CartItemCell.swift
//  SamsungStoreApp
//
//  Created by 서광용 on 6/26/25.

// MARK: Custom Cell View

import SnapKit
import UIKit

final class CartItemCell: UITableViewCell {
    private let itemLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(itemLabel) // UIKit이 자동생성한 contentView

        itemLabel.text = "제품명 테스트"
        itemLabel.textColor = .black

        itemLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
}
