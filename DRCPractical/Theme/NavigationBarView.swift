//
//  NavigationBarView.swift
//  DRCPractical
//
//  Created by Khushali on 01/07/23.
//


import UIKit

class NavigationBarView: UIView {

    //MARK: Outlet
    @IBOutlet var btnBack: UIButton!{
        didSet {
            btnBack.setTitle("", for: .normal)
        }
    }
   
    @IBOutlet var btnTrailing: UIButton!{
        didSet {
            btnTrailing.setTitle("", for: .normal)
        }
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        if onTappedBack != nil { self.onTappedBack!()}
    }
    @IBAction func btnTrailingAction(_ sender: UIButton) {
        if onTappedTrailingBtn != nil { self.onTappedTrailingBtn!()}
    }
    
    //MARK: Variables
    let navigationHeight:CGFloat = UINavigationController.topbarHeight
    var onTappedBack:(() ->  Void)?
    var onTappedTrailingBtn:(() ->  Void)?
    
}


extension UIViewController {
    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
            return topBarHeight
        }
    }
}


extension UINavigationController {
    static var topbarHeight: CGFloat {
        get {
            return 64
        }
        set {}
    }
}

