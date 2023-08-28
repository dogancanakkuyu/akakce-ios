import Foundation

enum NetworkError: Error {
    case urlError
    case connectionProblem
    case canNotParseData
}

class MockApiService {
    static func fetchProducts(endpoint: String,completion: @escaping (Root?,_ error:NetworkError?) -> Void) {
        
        guard let url = URL(string: endpoint) else{
            completion(nil, NetworkError.urlError)
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if error != nil {
                completion(nil,NetworkError.connectionProblem)
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                completion(nil, NetworkError.connectionProblem)
                return
            }
            
            if let data = data {
                
                do {
                    let decoded = try JSONDecoder().decode(Root.self, from: data)
                    completion(decoded,nil)
                } catch {
                    completion(nil,NetworkError.canNotParseData)
                }
            }
        }).resume()
        
    }
    static func fetchProductDetail(endpoint: String,code: Int,completion: @escaping (ProductDetailResponse?,_ error:NetworkError?) -> Void) {
        
        
        var url = URLComponents(string: endpoint)
        url?.queryItems = [URLQueryItem(name: "code", value: "\(code)")]
        
        guard let url = url else {
            completion(nil,NetworkError.urlError)
            return
        }
        let request = URLRequest(url: url.url!)
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if error != nil {
                completion(nil,NetworkError.connectionProblem)
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                completion(nil, NetworkError.connectionProblem)
                return
            }
            
            if let data = data {
            
                do {
                    let decoded = try JSONDecoder().decode(ProductDetailResponse.self, from: data)
                    completion(decoded,nil)
                } catch {
                    completion(nil,NetworkError.canNotParseData)
                }
            }
        }).resume()
        
    }
    
    
}

