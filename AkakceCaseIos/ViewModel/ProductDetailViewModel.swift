//
//  ProductDetailViewModel.swift
//  TestProject
//
//  Created by Doğacan AKINCI on 25.08.2023.
//

import Foundation

class ProductDetailViewModel {
    
    var apiResult : Observable<ProductDetail> = Observable(ProductDetail())
    
    func fetchProductDetail(endpoint: String, code: Int) {
        DispatchQueue.global().async {
            MockApiService.fetchProductDetail(endpoint: endpoint, code: code) {[weak self] data, error in
                if let error = error {
                    print("error: \(error)")
                    self?.apiResult.value = nil
                    
                }
                
                if let data = data {
                    self?.apiResult.value = data.result
                }
            }
        }
    }
}
