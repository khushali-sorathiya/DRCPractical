//
//  ProductTC.swift
//  DRCPractical
//
//  Created by Khushali on 01/07/23.
//

import UIKit

class ProductTC: UITableViewCell {
    
    @IBOutlet weak var viewMain: UIView!{
        didSet {
            viewMain.addShadow(offset: CGSize(width: -1, height: -1), color: AppColors.lightgray, radius: 4, opacity: 0.4)
            viewMain.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var btnFav: UIButton!{
        didSet {
            btnFav.setTitle("", for: .normal)
        }
    }
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblprice: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblCartCount: UILabel! {
        didSet {
            lblCartCount.layer.cornerRadius = 10
            lblCartCount.layer.borderColor = AppColors.primaryBlue.withAlphaComponent(0.7).cgColor
            lblCartCount.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var lblRate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    var cellData : productdata? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        if let data = cellData {
            imgProduct.downLoadImage(url: data.image)
            lbltitle.text = data.title
            lblDesc.text = data.desc
            lblprice.text = "\(data.price)"
            lblCartCount.text = "\(data.cartcount)"
            lblRate.text = "\(data.rating)"
            btnFav.setImage(UIImage(systemName: data.isFav ? "heart.fill": "heart"), for: .normal)
        }
    }
    
}
