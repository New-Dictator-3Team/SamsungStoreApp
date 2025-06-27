//
//  Product.swift
//  SamsungStoreApp
//
//  Created by 김우성 on 6/27/25.
//

import Foundation

struct Product: Codable {
    let image: String
    let name: String
    let price: Int
}

struct ProductCategory: Codable {
    let mobile: [Product]
    let tv_audio: [Product]
    let kitchen_appliances: [Product]
    let living_appliances: [Product]
}
