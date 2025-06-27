//
//  MenuCollectionView.swift
//  SamsungStoreApp
//
//  Created by 김우성 on 6/26/25.
//

import SnapKit
import UIKit

private enum CVLayoutConstants {
  static let cellSize = CGSize(width: 160, height: 160)
  static let lineSpacing: CGFloat = 24.0
  static let interItemSpacing: CGFloat = 24.0
  static let sectionInset = UIEdgeInsets(top: 24.0, left: 24.0, bottom: 24.0, right: 24.0)
}

class MenuCollectionView: UIView {
  // MARK: - 프로퍼티

  private var items: [MenuItem] = []
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = CVLayoutConstants.cellSize
    // layout.estimatedItemSize // 나중에 예상치 줘보자
    layout.minimumLineSpacing = CVLayoutConstants.lineSpacing
    layout.minimumInteritemSpacing = CVLayoutConstants.interItemSpacing
    layout.sectionInset = CVLayoutConstants.sectionInset
        
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.backgroundColor = .clear
    cv.isPagingEnabled = true
    
    cv.dataSource = self
    cv.delegate = self
    
    cv.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: MenuCollectionViewCell.reuseIdentifier)
    
    return cv
  }()
  
  // MARK: - 라이프사이클
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .blue
    setupViews()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - 셋업
  
  private func setupViews() {
    addSubview(collectionView)
    
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func update(data: [MenuItem]) {
    items = data
    collectionView.reloadData()
  }
}

// MARK: - UICollectionViewDataSource

extension MenuCollectionView: UICollectionViewDataSource {
  func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = cv.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.reuseIdentifier, for: indexPath) as? MenuCollectionViewCell else {
      fatalError("Failed to dequeue MenuCollectionViewCell")
    }
    cell.configure(with: items[indexPath.row])
    
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MenuCollectionView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ cv: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return .zero
  }
}
