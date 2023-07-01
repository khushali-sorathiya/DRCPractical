//
//  Color+Font.swift
//  DRCPractical
//
//  Created by Khushali on 01/07/23.
//


import UIKit

//MARK:- Color
class AppColors: UIColor {
    
    fileprivate struct AssestsName {
        static let primaryBlue = "PrimaryBlue"
        static let appRed = "AppRed"
        
        static let white = "White"
        static let black = "Black"
        
        static let lightGray = "lightGray"
        static let gray = "Gray"
        
    }
    
    static let primaryBlue:UIColor = UIColor(named: AssestsName.primaryBlue) ?? UIColor(red: 20.0 / 255.0, green: 56.0 / 255.0, blue: 124.0 / 255.0, alpha: 1.0)
    
    static let appRed:UIColor = UIColor(named: AssestsName.appRed) ?? UIColor(red: 226.0 / 255.0, green: 45.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0)
    static let lightgray:UIColor = UIColor(named: AssestsName.lightGray) ?? UIColor(red: 198.0 / 255.0, green: 198.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
    static let Gray :UIColor = UIColor(named: AssestsName.gray) ?? UIColor(displayP3Red: 142.0 / 255.0, green: 142.0 / 255.0, blue: 146.0  / 255.0, alpha: 1.0)
    
    static let appWhite = UIColor(named: AssestsName.white) ?? UIColor.white
    static let appBlack = UIColor(named: AssestsName.black) ?? UIColor.black

}

extension UIColor {
    // Create a UIColor from RGB
    convenience init(r: Int, g: Int, b: Int, alpha: CGFloat = 1.0) {
        assert(r >= 0 && r <= 255, "Invalid red component")
        assert(g >= 0 && g <= 255, "Invalid green component")
        assert(b >= 0 && b <= 255, "Invalid blue component")
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    //For generate code base on hex code follow this link: http://uicolor.xyz/#/hex-to-ui
    // Create a UIColor from a hex value (E.g 0x000000)
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            r: (hex >> 16) & 0xFF,
            g: (hex >> 8) & 0xFF,
            b: hex & 0xFF,
            alpha: a
        )
    }
}
