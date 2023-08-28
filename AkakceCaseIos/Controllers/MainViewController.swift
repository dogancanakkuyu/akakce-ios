//
//  ViewController.swift
//  TestProject
//
//  Created by Doğacan AKINCI on 24.08.2023.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var horizontalCollectionView: UICollectionView!
    
    @IBOutlet weak var verticalCollectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    var mainViewModel : MainViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpController()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sendDataRequest()
    }
    
    func setUpController() {
        mainViewModel = MainViewModel()
        horizontalCollectionView.dataSource = self
        horizontalCollectionView.delegate = self
        verticalCollectionView.dataSource = self
        verticalCollectionView.delegate = self
        bindViewModel()
    }
    
    
    
    func sendDataRequest() {
        
        if(mainViewModel.horizontalProducts.value?.count == 0) {
            mainViewModel.fetchDataFromMockApi(endpoint: Constant.PRODUCTS_ENDPOINT)
        }
        
    }
    
    func manageVerticalPagination(response: Result) {
        let currentItemCount = self.verticalCollectionView.numberOfItems(inSection: 0)
        var newIndexPaths: [IndexPath] = []
        for i in 0..<response.products.count {
            let indexPath = IndexPath(item: currentItemCount + i, section: 0)
            newIndexPaths.append(indexPath)
        }
        self.verticalCollectionView.performBatchUpdates({
            self.verticalCollectionView.insertItems(at: newIndexPaths)
        }, completion: nil)
    }
    
    func bindViewModel() {
        mainViewModel.apiResult.bind { [weak self] response in
            guard let self = self, let response = response else {
                return
            }
            
            DispatchQueue.main.async {
                self.manageVerticalPagination(response: response)
            }
        }
        mainViewModel.horizontalProducts.bind { [weak self] product in
            guard let self = self,let product = product else {
                return
            }
            DispatchQueue.main.async {
                if let horizontalProductCnt = self.mainViewModel.horizontalProducts.value?.count {
                    if horizontalProductCnt > 0 {
                        self.horizontalCollectionView.reloadData()
                        self.pageControl.numberOfPages = product.count
                        self.pageControl.currentPage = 0
                        self.pageControl.isHidden = false
                    }
                }
                
            }
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constant.MAIN_TO_PRODUCT_DETAIL_SEG_ID) {
            if let detailVC = segue.destination as? ProductDetailViewController {
                if let code = sender as? Int {
                    detailVC.modalPresentationStyle = .currentContext
                    detailVC.code = code
                }
            }
        }
    }
    

}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == horizontalCollectionView) {
            return mainViewModel.horizontalProducts.value?.count ?? 0
        }
        return mainViewModel.verticalProducts.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let horizontalProducts = mainViewModel.horizontalProducts.value ?? []
        let verticalProducts = mainViewModel.verticalProducts.value ?? []
        if(collectionView == horizontalCollectionView) {
            let cell = horizontalCollectionView.dequeueReusableCell(withReuseIdentifier: "horizontalCollectionCell", for: indexPath) as! ProductCollectionViewCell
                    cell.setUpCell(product: horizontalProducts[indexPath.row])
                    return cell
        }
        let cell = verticalCollectionView.dequeueReusableCell(withReuseIdentifier: "verticalCollectionCell", for: indexPath) as! VerticalCollectionViewCell
                cell.setUpCell(product: verticalProducts[indexPath.row])
                return cell
        
    }
    
    
    
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == horizontalCollectionView) {
            let horizontalProducts = mainViewModel.horizontalProducts.value ?? []
            let code = horizontalProducts[indexPath.row].code
            //let vc = storyboard?.instantiateViewController(withIdentifier: "productViewController") as? ProductDetailViewController
            //vc?.code = code //this is the data which will be passed to the new vc
            performSegue(withIdentifier: Constant.MAIN_TO_PRODUCT_DETAIL_SEG_ID, sender: code)
            //self.navigationController?.pushViewController(vc!, animated: true)
        }
        else {
            let products = mainViewModel.verticalProducts.value ?? []
            let code = products[indexPath.row].code
            performSegue(withIdentifier: Constant.MAIN_TO_PRODUCT_DETAIL_SEG_ID, sender: code)
        }
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let nextUrl = mainViewModel.apiResult.value?.nextURL {
            mainViewModel.fetchDataFromMockApi(endpoint: nextUrl)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView == horizontalCollectionView) {
            let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
            pageControl.currentPage = currentPage
        }
    }
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == horizontalCollectionView) {
            let verticalPad: CGFloat = 40
            return CGSize(width: horizontalCollectionView.bounds.size.width , height: horizontalCollectionView.bounds.size.height - verticalPad)
        }
        
        let padding :CGFloat = 40
        let verticalPad: CGFloat = 30
        let collectionViewSize = verticalCollectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize / 2, height: verticalCollectionView.frame.size.height / 1.5 - verticalPad)
    }
}



