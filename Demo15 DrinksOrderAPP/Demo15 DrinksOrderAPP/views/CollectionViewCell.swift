//
//  CollectionViewCell.swift
//  Demo15 DrinksOrderAPP
//
//  Created by LukeLin on 2022/2/21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var menubodyImage: UIImageView!
    @IBOutlet var menubodyNameLabel: UILabel!
    @IBOutlet var menubodyPriceLabel: UILabel!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHighConstraint: NSLayoutConstraint!
    static let width = floor(Double((UIScreen.main.bounds.width-140)/2))
    
    override func awakeFromNib() {
        
        imageWidthConstraint.constant =  Self.width
        imageHighConstraint.constant = 80
        menubodyImage.layer.cornerRadius = 10
        menubodyImage.layer.borderWidth = 1
        menubodyImage.layer.borderColor = CGColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        
      }
}
