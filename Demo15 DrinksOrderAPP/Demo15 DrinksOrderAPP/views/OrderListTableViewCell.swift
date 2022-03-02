//
//  OrderListTableViewCell.swift
//  Demo15 DrinksOrderAPP
//
//  Created by LukeLin on 2022/2/26.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {

    @IBOutlet var numberImage: UIImageView!
    @IBOutlet var drinkImage: UIImageView! {
        didSet {
            drinkImage.layer.cornerRadius = 15
            drinkImage.layer.masksToBounds = true
            drinkImage.layer.borderWidth = 2
            drinkImage.layer.borderColor = CGColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        }
    }
    @IBOutlet var orderernameLabel: UILabel!
    @IBOutlet var drinknameLabel: UILabel!
    @IBOutlet var addtionLabel: UILabel!
    @IBOutlet var remarkLabel: UILabel!
    @IBOutlet var loadingActivityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
