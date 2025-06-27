//
//  ProductPageView.swift
//  SamsungStoreApp
//
//  Created by 김우성 on 6/27/25.
//

import UIKit
import SnapKit

protocol ProductPageViewDelegate: AnyObject {
  func productPageView(_ view: ProductPageView, didSelect product: Product)
}

final class ProductPageView: UIView {

  // MARK: - UI
  private let collectionView: UICollectionView
  private let pageControl = UIPageControl()
  
  // MARK: - Data
  private var products: [Product] = []
  weak var delegate: ProductPageViewDelegate?
  
  // MARK: - Init
  override init(frame: CGRect) {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    self.collectionView.isPagingEnabled = true
    self.collectionView.showsHorizontalScrollIndicator = false
    
    super.init(frame: frame)
    
    setupView()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  private func setupView() {
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(ProductPageCell.self, forCellWithReuseIdentifier: "ProductPageCell")
    
    addSubview(collectionView)
    addSubview(pageControl)
    
    pageControl.currentPageIndicatorTintColor = AppColorType.highlight
    pageControl.pageIndicatorTintColor = AppColorType.division
    pageControl.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)
  }

  private func setupConstraints() {
    collectionView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(pageControl.snp.top).offset(-8)
    }
    pageControl.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.centerX.equalToSuperview()
      $0.height.equalTo(24)
    }
  }
  
  // MARK: - Public API
  func configure(with products: [Product]) {
    self.products = products
    let pageCount = Int(ceil(Double(products.count) / 4.0))
    pageControl.numberOfPages = pageCount
    collectionView.reloadData()
  }

  // MARK: - Actions
  @objc private func pageControlTapped() {
    let xOffset = CGFloat(pageControl.currentPage) * collectionView.bounds.width
    collectionView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
  }
}

extension ProductPageView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return Int(ceil(Double(products.count) / 4.0))
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let startIndex = section * 4
    return min(4, products.count - startIndex)
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductPageCell", for: indexPath) as? ProductPageCell else {
      return UICollectionViewCell()
    }

    let startIndex = indexPath.section * 4
    let endIndex = min(startIndex + 4, products.count)
    let subset = Array(products[startIndex..<endIndex])
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
