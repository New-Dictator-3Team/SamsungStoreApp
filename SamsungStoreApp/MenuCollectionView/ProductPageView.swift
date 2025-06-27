//
//  ProductPageView.swift
//  SamsungStoreApp
//
//  Created by 김우성 on 6/27/25.
//

import SnapKit
import UIKit

protocol ProductPageViewDelegate: AnyObject {
  func productPageView(_ view: ProductPageView, didSelect product: ProductItem)
  
}

final class ProductPageView: UIView {
  // MARK: - UI

  private let collectionView: UICollectionView
  private let pageControl = UIPageControl()

  // MARK: - Data

  private var products: [ProductItem] = []
  weak var delegate: ProductPageViewDelegate?

  // MARK: - Init

  override init(frame: CGRect) {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0

    self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isPagingEnabled = true
    collectionView.showsHorizontalScrollIndicator = false

    super.init(frame: frame)

    setupView()
    setupConstraints()
  }

  @available(*, unavailable)
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
      $0.bottom.equalToSuperview().offset(-8)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(8)
    }
  }

  // MARK: - Public API

  /// 외부에서 전달된 [ProductItem]를 저장하고, collectionView와 pageControl을 업데이트합니다.
  func configure(with products: [ProductItem]) {
    self.products = products
    let pageCount = Int(ceil(Double(products.count) / 4.0))
    pageControl.numberOfPages = pageCount
    collectionView.reloadData()
    
    // 리로드 후 페이지컨트롤 첫번째로, 그리고 컬렉션뷰 위치도 초기화
    pageControl.currentPage = 0
    collectionView.setContentOffset(.zero, animated: false)
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
