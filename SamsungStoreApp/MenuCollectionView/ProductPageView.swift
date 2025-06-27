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
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    
    // MARK: - Data
    private var products: [Product] = []
    private var productCells: [ProductGridCell] = []
    
    // MARK: - Layout Constants
    private let spacing: CGFloat = 12
    private let itemsPerPage = 4
    
    // MARK: - Delegate
    weak var delegate: ProductPageViewDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public API
    func configure(with products: [Product]) {
        self.products = products
        setNeedsLayout()
    }
    
    // MARK: - Setup
    private func setupViews() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        addSubview(scrollView)
        addSubview(pageControl)
        pageControl.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(pageControl.snp.top).offset(-8)
        }
        pageControl.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        }
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutProducts()
    }

    private func layoutProducts() {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        productCells.removeAll()
        
        let pageCount = Int(ceil(Double(products.count) / Double(itemsPerPage)))
        pageControl.numberOfPages = pageCount
        
        let w = bounds.width
        let h = scrollView.bounds.height
        let cellW = (w - spacing * 3) / 2
        let cellH = (h - spacing * 3) / 2
        
        scrollView.contentSize = CGSize(width: w * CGFloat(pageCount), height: h)
        
        for (idx, product) in products.enumerated() {
            let page = idx / itemsPerPage
            let pos = idx % itemsPerPage
            let row = pos / 2
            let col = pos % 2
            let x = CGFloat(page) * w + CGFloat(col) * (cellW + spacing) + spacing
            let y = CGFloat(row) * (cellH + spacing) + spacing
            
            let cell = ProductGridCell(frame: CGRect(x: x, y: y, width: cellW, height: cellH))
            cell.product = product
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:))))
            scrollView.addSubview(cell)
            productCells.append(cell)
        }
    }

    // MARK: - Actions
    @objc private func pageControlTapped() {
        let x = CGFloat(pageControl.currentPage) * scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }

    @objc private func cellTapped(_ g: UITapGestureRecognizer) {
        if let cell = g.view as? ProductGridCell,
           let product = cell.product {
            delegate?.productPageView(self, didSelect: product)
        }
    }
}

extension ProductPageView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
    }
}
