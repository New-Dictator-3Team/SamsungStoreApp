//
//  ProductPageView.swift
//  SamsungStoreApp
//
//  Created by 김우성 on 6/27/25.
//

import SnapKit
import UIKit

// MARK: - 델리게이트 프로토콜

protocol ProductPageViewDelegate: AnyObject {
  func productPageView(_ view: ProductPageView, didSelect product: ProductItem)
}

// MARK: - ProductPageView

final class ProductPageView: UIView {
  // MARK: - UI 컴포넌트
  
  private let collectionView: UICollectionView
  private let pageControl = UIPageControl()
  
  // MARK: - 데이터
  
  private var products: [ProductItem] = []
  weak var delegate: ProductPageViewDelegate?
  
  // MARK: - 초기화
  
  override init(frame: CGRect) {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    super.init(frame: frame)
    
    setupUI()
    setupLayout()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI 세팅
  
  private func setupUI() {
    collectionView.isPagingEnabled = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.register(ProductPageCell.self, forCellWithReuseIdentifier: "ProductPageCell")
    collectionView.dataSource = self
    collectionView.delegate = self
    
    pageControl.currentPageIndicatorTintColor = AppColorType.highlight
    pageControl.pageIndicatorTintColor = AppColorType.division
    pageControl.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)
    
    [collectionView, pageControl].forEach(addSubview)
  }
  
  private func setupLayout() {
    collectionView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(pageControl.snp.top).offset(-8)
    }
    pageControl.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-8)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(8)
    }
  }
  
  // MARK: - 구성
  
  func configure(with products: [ProductItem]) {
    self.products = products
    pageControl.numberOfPages = Int(ceil(Double(products.count) / 4.0))
    pageControl.currentPage = 0
    collectionView.setContentOffset(.zero, animated: false)
    collectionView.reloadData()
  }
  
  // MARK: - 액션
  
  @objc private func pageControlTapped() {
    let x = CGFloat(pageControl.currentPage) * collectionView.bounds.width
    collectionView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
  }
}

// MARK: - UICollectionView 데이터 소스 & 델리게이트

extension ProductPageView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    Int(ceil(Double(products.count) / 4.0))
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductPageCell", for: indexPath) as? ProductPageCell else {
      return UICollectionViewCell()
    }
    
    let startIndex = indexPath.section * 4
    let endIndex = min(startIndex + 4, products.count)
    let subset = Array(products[startIndex ..< endIndex])
    cell.configure(with: subset)
    cell.tapHandler = { [weak self] product in
      self?.delegate?.productPageView(self!, didSelect: product)
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return collectionView.bounds.size
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    pageControl.currentPage = page
  }
}
