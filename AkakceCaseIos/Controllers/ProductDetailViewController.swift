//
//  ProductDetailViewController.swift
//  TestProject
//
//  Created by Doğacan AKINCI on 24.08.2023.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    var code: Int?
    var productDetailViewModel = ProductDetailViewModel()
    
    
    @IBOutlet weak var mkName: UILabel!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var badge: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    
    @IBOutlet weak var vendorsCount: UILabel!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var shippingStatus: UILabel!
    @IBOutlet weak var lastUpdate: UILabel!
    
    
    @IBOutlet weak var screenView: UIView!
    
    @IBOutlet weak var storageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storageCollectionView.dataSource = self
        storageCollectionView.delegate = self
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sendRequest()
    }
    
    
    func sendRequest() {
        productDetailViewModel.fetchProductDetail(endpoint: Constant.PRODUCT_DETAIL_ENDPOINT, code: code!)
    }
    
    
    func setUI(productDetail: ProductDetail) {
        
        DispatchQueue.global().async {
            let imageUrl = URL(string: productDetail.imageUrl)
            if let imageUrl = imageUrl {
                let data = try? Data(contentsOf: imageUrl)
                if let data = data {
                    DispatchQueue.main.async {
                        self.image.image = UIImage(data: data)
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.mkName.text = productDetail.mkName
            self.productName.text = productDetail.productName
            self.badge.text = productDetail.badge
            self.vendorsCount.text = "\(productDetail.countOfPrices)" + " satıcı içinde kargo dahil en ucuz fiyat seçeneği"
            self.price.text = "\(productDetail.price)" + " TL"
            self.lastUpdate.text = "Son güncelleme: " + "\(productDetail.lastUpdate)"
            self.shippingStatus.text = (productDetail.freeShipping == true) ? "Ücretsiz Kargo" : ""
            self.screenView.isHidden = true
        }
        
    }
    
    
    
    func bindViewModel() {
        productDetailViewModel.apiResult.bind { [weak self] productDetail in
            guard let self = self, let productDetail = productDetail else {
                return
            }
            if (productDetail.mkName != "") {
                setUI(productDetail: productDetail)
            }
            
            DispatchQueue.main.async {
                self.storageCollectionView.reloadData()
            }
            
        }
    }

    

}

extension ProductDetailViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDetailViewModel.apiResult.value?.storageOptions.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = storageCollectionView.dequeueReusableCell(withReuseIdentifier: "storageCell", for: indexPath) as! StorageViewCell
        let storageOptions = productDetailViewModel.apiResult.value?.storageOptions ?? []
        
        cell.setUpCell(storage: storageOptions[indexPath.row])
        return cell
    }
}

extension ProductDetailViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let hPadding: CGFloat = 40
        let heightRatio = 42.0 / 667.0
        let width = storageCollectionView.frame.size.width - hPadding
        return CGSize(width: width / 3, height: view.frame.height * heightRatio)
    }
}
