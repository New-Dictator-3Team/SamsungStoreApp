//
//  ViewController.swift
//  SamsungStoreApp
//
//  Created by estelle on 6/26/25.
//

import SnapKit
import UIKit

final class ViewController: UIViewController {
// MARK: - 프로퍼티

  private var categories: [Category] = []
  private var selectedCategory = "모바일"
  private let dataService = DataService()
  
  private let mainView = UIView()
  private let categoryTabView = CategoryTabView()
  private let productPageView = ProductPageView()
  private let cartView = UIView() // 더미 뷰
  private let bottomView = BottomView()
  
  // MARK: - 라이프사이클
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupLayout()
    loadCategoryData()
    testLink()
  }
 
    // Menu와 Cart 부분 합치는 임시 코드
    private func testLink() {
      // CartViewController 인스턴스 생성
      let cartVC = CartViewController()
      productPageView.delegate = cartVC
      addChild(cartVC) // 자식으로 추가
      cartView.addSubview(cartVC.view) // 뷰만 하위에 추가
      cartVC.didMove(toParent: self) // 부모-자식 연결 완료
      cartVC.view.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
    
    // MARK: - UI 세팅
    
    private func setupUI() {
      view.backgroundColor = .systemBackground
      view.addSubview(mainView)
      
      for item in [categoryTabView, productPageView, cartView, bottomView] {
        mainView.addSubview(item)
      }
      
      categoryTabView.delegate = self
      productPageView.delegate = self
    }
    
    private func setupLayout() {
      mainView.snp.makeConstraints {
        $0.edges.equalTo(view.safeAreaLayoutGuide)
      }
      
      categoryTabView.snp.makeConstraints {
        $0.top.leading.trailing.equalToSuperview()
        //$0.height.equalTo(76) // 얘가 범근님 뷰컨엔 없음
      }
      
      productPageView.snp.makeConstraints {
        $0.top.equalTo(categoryTabView.snp.bottom)
        $0.leading.trailing.equalToSuperview()
        $0.bottom.equalTo(cartView.snp.top)
      }
      
      cartView.snp.makeConstraints {
        $0.leading.trailing.equalToSuperview()
        $0.bottom.equalTo(bottomView.snp.top)
        $0.height.equalTo(250)
      }
      
      bottomView.snp.makeConstraints {
        $0.leading.trailing.bottom.equalToSuperview()
        $0.height.equalTo(50)
      }
    }
    
    // MARK: - 데이터 바인딩
    
    private func loadCategoryData() {
      dataService.loadCategories { [weak self] result in
        guard let self = self else { return }
        switch result {
        case let .success(loadedCategories):
          self.categories = loadedCategories
          DispatchQueue.main.async {
            self.categoryTabView.configure(categories: loadedCategories.map { $0.category })
            if let defaultItems = loadedCategories.first(
              where: {
                $0.category == self.selectedCategory
              })?.items
            {
              print("✅ 불러온 카테고리 수: \(loadedCategories.count)")
              self.productPageView.configure(with: defaultItems)
            }
          }
        case let .failure(error):
          print("🚨 데이터 로딩 실패: \(error)")
        }
      }
  //    dataService.jsonDebug()
    }
}

// MARK: - 델리게이트

extension ViewController: CategoryTabViewDelegate, ProductPageViewDelegate {
  func didTapCategoryButton(selectedCategoryIndex: Int) {
    let selectedItems = categories[selectedCategoryIndex].items
    productPageView.configure(with: selectedItems)
  }

  func productPageView(_ view: ProductPageView, didSelect product: ProductItem) {
    print("선택한 상품: \(product.name), 가격: \(product.price)")
    // 광용님 내용
  }
}
