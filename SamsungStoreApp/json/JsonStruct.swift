//
//  JsonStruct.swift
//  SamsungStoreApp
//
//  Created by 김우성 on 6/27/25.
//

import Foundation

 // MARK: - ProductItem

 struct ProductItem: Decodable {
   let image: String
   let name: String
   let price: String
 }

 // MARK: - Category

 struct Category: Decodable {
   let category: String
   let items: [ProductItem]
 }

 // MARK: - CategoryResponse

 struct CategoryResponse: Decodable {
   let categories: [Category]
 }
