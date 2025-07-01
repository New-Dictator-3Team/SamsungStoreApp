# 📦 SamsungStoreApp

> iOS에서 실행되는 **삼성 키오스크 스타일 주문 앱**입니다.

실제로는 iPhone에서 돌아가는 **"삼성스토어 키오스크 UI"**라는 재미있는 콘셉트로 구현되었습니다 😎  
상단 카테고리, 상품 목록, 장바구니, 결제 플로우까지 전반적인 쇼핑 UI를 체험할 수 있습니다.

<br>

## 📱 아이폰 기기별 시연 영상
- 다양한 화면 크기에서의 UI 반응형 확인 가능
  - iPhone SE (2nd generation)
  - iPhone 13 mini
  - iPhone 11
  - iPhone 16 Pro Max

| iPhone SE (3rd Gen) | iPhone 13 mini |
|---------------------|----------------|
| ![Image](https://github.com/user-attachments/assets/7019756b-5155-42b2-bae1-c7d4c0fc310c) | ![Image](https://github.com/user-attachments/assets/dbf09f7c-6e30-4322-9a3c-f6d47d5306fe) |

| iPhone 11 | iPhone 16 Pro Max |
|-----------|-------------------|
| ![Image](https://github.com/user-attachments/assets/8c7dd720-1ef5-4c40-9480-ecf99c11d72a) | ![Image](https://github.com/user-attachments/assets/6eb8e31b-5f9b-4ea0-9d0f-755ea7486257) |

| 다국어 지원 |
|------------------|
| ![Image](https://github.com/user-attachments/assets/54bf168c-71c6-4493-9645-afa5dd6adfc4) |

## 🧭 기능 요약

🏠 메인 화면
- MainViewController 하나로 모든 화면 구성
- 상단 카테고리, 상품 목록, 장바구니, 총 개수/금액, 하단 버튼 포함
- 모든 요소는 하나의 UIScrollView 내에 구성되어, 자연스럽게 세로 스크롤 가능

### 📂 카테고리
- 모바일, TV/영상/음향, 주방가전, 리빙가전, PC/주변기기 다섯 개 카테고리 구성
- UIScrollView와 UIStackView로 구현된 탭 메뉴 (CategoryTabView)

### 🛒 상품 목록
- UICollectionView로 구현된 상품 목록
- GridCell이 2 x 2 형태로 보여짐
- 좌우 페이지 넘김으로 전체 상품 탐색 가능 (페이징)
- 하단에는 현재 페이지를 나타내는 페이지 인디케이터 표시
- 페이지 인디케이터를 길게 눌러 손가락 좌우 이동하면 상품 목록도 그에 맞춰 페이지 전환됨

### 🪣 장바구니
- UITableView 기반의 장바구니 구현
- CartItemCell로 구성된 각 셀에는 상품명, 수량 조절 + / - 버튼, 삭제 버튼 포함
- 개수가 1개 이하일 때 -를 누르면 삭제되므로, 이때는 휴지통 아이콘으로 변경함
- 이미 담긴 상품을 다시 선택하면 수량만 증가 (최대 수량은 25개까지 제한)

### 💰 총 개수/금액
- CartSummaryView를 통해 장바구니 하단에 총 주문 개수 및 총 결제 금액이 항상 함께 표시됨

### 💳 취소/결제 플로우
- 취소 시 Alert으로 확인 후 장바구니 초기화
- 결제 시 Alert 후 장바구니 초기화 및 첫 카테고리로 이동
- 장바구니가 비어있을 경우 하단 버튼(전체 취소, 결제하기) 비활성화

<br>

## 📁 폴더 구조

```plaintext
SamsungStoreApp/
├── Controller/
│   ├── ViewController.swift
│   └── ViewController+Delegate.swift
│
├── Model/
│   ├── CartItem.swift
│   └── JsonStruct.swift
│
├── Resource/
│   ├── Data/
│   │   └── Product.json          # 실제 메뉴 JSON 데이터
│   ├── Fonts/
│   │   └── 삼성체 폰트(woff2)
│   ├── Assets/
│   │   └── Colors.xcassets, 메뉴 이미지 등
│   └── Localizable/
│       ├── Localizable.strings (English)
│       └── Localizable.strings (Korean)
│
├── View/
│   ├── CartView/
│   │   ├── CartItemCell.swift
│   │   ├── CartSummaryView.swift
│   │   └── CartView.swift
│   ├── ProductPageView/
│   │   ├── ProductGridCell.swift
│   │   └── ProductPageView.swift
│   ├── CategoryTabView/
│   │   └── CategoryTabView.swift
│   └── BottomView/
│       └── BottomButton.swift
```

<br>

## 🗂 데이터 구조 예시 (Resource/menu.json)
```json
{
  "categories": [
    {
      "categoryKey": "category.mobile",
      "items": [
        { "image": "1-1.png", "nameKey": "item.galaxy_s25_edge", "price": "1,465,200" },
        { "image": "1-2.png", "nameKey": "item.galaxy_s25_ultra", "price": "1,645,800" },
        ...
      ]
    },
    ...
  ]
}
```
- 각 카테고리는 categoryKey로 식별되며, 내부에는 제품 리스트가 존재합니다.
- 제품마다 image, nameKey, price가 포함됩니다.
- nameKey는 다국어를 지원하기 위한 localization key입니다.

<br>

## 🎯 개발자 가이드
- 스토리보드 없이 100% 코드 기반 UI
- SnapKit을 이용한 레이아웃 구성
- Alert, 버튼 활성화 제어 로직 등은 ViewController에서 관리
- 다국어 지원 (Localizable.strings)
- 다크모드 지원
- 총 40개 이상의 제품 목록

<br>

## 🚀 설치 및 실행 방법
1.	이 저장소 클론
```
git clone https://github.com/New-Dictator-3Team/SamsungStoreApp.git
cd SamsungStoreApp/SamsungStoreApp
```

2. Xcode에서 .xcodeproj 또는 .xcworkspace 열기
3. 실행 환경: iOS 16+ / Swift 5.7+
4. 시뮬레이터 또는 실제 iPhone에서 실행

<br>
