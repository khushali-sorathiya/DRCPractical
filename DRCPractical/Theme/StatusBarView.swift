//
//  StatusBarView.swift
//  DRCPractical
//
//  Created by Khushali on 01/07/23.
//

import UIKit

class StatusBarView: UIView {

    @IBOutlet var statusBarView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusBarView.backgroundColor = AppColors.primaryBlue
    }
    

}
