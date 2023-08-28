import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var countOfPrices: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var followCount: UILabel!
    
    @IBOutlet weak var dropRatio: UILabel!
    @IBOutlet weak var dropRatioView: UIView!
    
    
    
    func setUpCell(product: Product) {
        
        DispatchQueue.global().async {
            let imageUrl = URL(string: product.imageURL)
            if let imageUrl = imageUrl {
                let data = try? Data(contentsOf: imageUrl)
                if let data = data {
                    DispatchQueue.main.async {
                        self.productImage.image = UIImage(data: data)
                    }
                }
            }
        }
        
        if (product.dropRatio != nil) {
            self.dropRatio.text = "%\(product.dropRatio!)"
            dropRatioView.layer.cornerRadius = frame.width * 0.05
            self.dropRatioView.isHidden = false
        }
        else {
            self.dropRatioView.isHidden = true
        }
        
        productName.text = product.name
        price.text = "\(product.price) TL"
        
        if let priceCount = product.countOfPrices {
            countOfPrices.text = "\(priceCount) satıcı >"
        }
        else {
            countOfPrices.text = "0 satıcı >"
        }
        if let followers = product.followCount {
            followCount.text = "\(followers) takip"
        }
        else {
            followCount.text = "0 takip"
        }
    }
}
