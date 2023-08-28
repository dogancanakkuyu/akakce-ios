//
//  StorageViewCell.swift
//  TestProject
//
//  Created by Doğacan AKINCI on 25.08.2023.
//

import UIKit

class StorageViewCell: UICollectionViewCell {
    
    @IBOutlet weak var storageVal: UILabel!
    
    @IBOutlet weak var borderView: UIView!
    func setUpCell(storage: String) {
        self.storageVal.text = storage
        borderView.layer.borderWidth = 2
        borderView.layer.borderColor = CGColor(#colorLiteral(red: 0.9411764741, green: 0.9411764741, blue: 0.9411764741, alpha: 1))
    }
    
}
