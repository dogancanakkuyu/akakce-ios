//
//  ProductDetail.swift
//  TestProject
//
//  Created by Doğacan AKINCI on 25.08.2023.
//

import Foundation

struct ProductDetail: Codable {
    let mkName: String
    let productName: String
    let badge: String
    let rating: Double
    let imageUrl: String
    let storageOptions: [String]
    let countOfPrices: Int
    let price: Int
    let freeShipping: Bool
    let lastUpdate: String
    
    init() {
        mkName = ""
        productName = ""
        badge = ""
        rating = 0.0
        imageUrl = ""
        storageOptions = []
        countOfPrices = 0
        price = 0
        freeShipping = false
        lastUpdate = ""
    }
}

struct ProductDetailResponse: Codable {
    let result: ProductDetail
}
