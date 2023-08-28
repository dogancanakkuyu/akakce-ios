import Foundation


class MainViewModel {
    var apiResult : Observable<Result> = Observable(Result())
    var verticalProducts: Observable<[Product]> = Observable([])
    var horizontalProducts: Observable<[Product]> = Observable([])
    func fetchDataFromMockApi(endpoint: String) {
        DispatchQueue.global().async {
            MockApiService.fetchProducts(endpoint: endpoint) {[weak self] data, error in
                if let error = error {
                    print("error: \(error)")
                    self?.apiResult.value = nil
                    
                }
                
                if let data = data,let self = self {
                    self.apiResult.value = data.result
                    self.verticalProducts.value?.append(contentsOf: data.result.products)
                    if let horizontalList = data.result.horizontalProducts {
                        self.horizontalProducts.value?.append(contentsOf: horizontalList)
                    }
                }
            }
        }
    }
    
    
}
