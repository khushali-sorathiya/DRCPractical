//
//  Extensions.swift
//  DRCPractical
//
//  Created by Khushali on 01/07/23.
//

import Foundation
import UIKit
import AlamofireImage

//MARK: String
extension String {
    var trimmedString: String { return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
    
    var isNumber: Bool {
        return !isEmpty && range(of: "[^0-9+]", options: .regularExpression) == nil
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    //Email Validation
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPhoneNo: Bool{
        get{
            let REGEX: String
            REGEX = "(^((\\+)|(00))[0-9]+|[0-9]+)"
            return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: self)
        }
    }
  
    var isBlank: Bool {
        get{
            return self.trimmingCharacters(in: .whitespaces).isEmpty
        }
    }
    
    func getStringInMutipleColor(strings : [String], colors : [UIColor]) -> NSAttributedString {
        
        let attributeString = NSMutableAttributedString()
        if strings.count == colors.count {
            for index in 0 ..< strings.count {
                let str = NSAttributedString(string: strings[index] , attributes: [NSAttributedString.Key.foregroundColor : colors[index]])
                attributeString.append(str)
            }
        }
        return attributeString
    }
    
   
}

//MARK: UIViewController
extension UIViewController {
  
    static var identifier: String {
        return String(describing: self)
    }
    
    func showAlert(message: String?, action: String = "OK", title: String = "") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message ?? "Something wrong", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: action, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertWithBlock(title: String, message: String?, buttonTitle: String, completion:@escaping () -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message ?? "Something wrong", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { (action) in
                completion()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertWithButton(title: String, message: String?, negativeTitle: String, positiveTitle:String,isRed:Bool = false, completion:@escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message ?? "Something wrong", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: negativeTitle, style: .cancel, handler: { (action) in
                completion(false)
            }))
            if isRed {
                alert.addAction(UIAlertAction(title: positiveTitle, style: .destructive, handler: { (action) in
                    completion(true)
                }))
            }else {
                alert.addAction(UIAlertAction(title: positiveTitle, style: .default, handler: { (action) in
                    completion(true)
                }))
            }
            
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setHomeRootViewController() {
        DispatchQueue.main.async {
            let objVC = HomeVC.storyboardInstance
            let objNavVC = UINavigationController(rootViewController: objVC)
            objNavVC.interactivePopGestureRecognizer?.isEnabled = false
            objNavVC.navigationBar.isHidden = true
            self.view.window?.rootViewController = objNavVC
            self.view.window?.makeKeyAndVisible()
        }
    }
    
}

//MARK: UIView
extension UIView {
    
    
    
    func bringToFront() {
        self.superview?.bringSubviewToFront(self)
    }
  
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
    
    func border(side: BorderSide = .all, color:UIColor = UIColor.black, borderWidth:CGFloat = 1.0) {
        
        let border = CALayer()
        border.borderColor = color.cgColor
        border.borderWidth = borderWidth
        
        switch side {
        case .all:
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = color.cgColor
        case .top:
            border.frame = CGRect(x: 0, y: 0, width:self.frame.size.width ,height: borderWidth)
        case .bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width:self.frame.size.width ,height: borderWidth)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: self.frame.size.height)
        case .right:
            border.frame = CGRect(x: self.frame.size.width - borderWidth, y: 0, width: borderWidth, height: self.frame.size.height)
        case .customRight:
            border.frame = CGRect(x: self.frame.size.width - borderWidth - 8, y: 8, width: borderWidth, height: self.frame.size.height - 16)
        case .customBottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - 1, width:self.frame.size.width ,height: borderWidth)
        }
        
        if side.rawValue != 0 {
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
        }
        
    }
}


enum BorderSide: Int {
    case all = 0, top, bottom, left, right, customRight, customBottom
}


//MARK: UItextfield
extension UITextField {
    
    func resetTextField() {
        self.resignFirstResponder()
        self.text = nil
    }
    
    func setPlaceHolderColor(color: UIColor){
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? " " , attributes: [NSAttributedString.Key.foregroundColor : color])
    }
    
    func setTextFiledAsRequired(string: String = "*", color: UIColor = UIColor.systemRed) {
        if let placeholder = self.placeholder {
            self.attributedPlaceholder = placeholder.getStringInMutipleColor(strings: ["\(self.placeholder ?? "") (",string,")"], colors: [AppColors.lightgray,color,AppColors.lightgray])
        }
    }
    
    func addClearButton() {
        let arrowButton:UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: 17, height: 17)
            button.backgroundColor = .clear
            button.tintColor = AppColors.Gray
            button.imageEdgeInsets.left = -15
            button.addTarget(self, action: #selector(didTapBtnArrow), for: .touchUpInside)
            return button
        }()
        self.rightView = arrowButton
        self.rightViewMode = .always
    }
    @objc private func didTapBtnArrow(_ sender:UIButton){
        if let textField = sender.superview as? UITextField{
            textField.text = ""
        }
    }
    
    func addPasswordToggel() {
        let passwordToggelButton:UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "eye.fill")!.withRenderingMode(.alwaysTemplate), for: .selected)
            button.setImage(UIImage(systemName: "eye.slash.fill")!.withRenderingMode(.alwaysTemplate), for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: (self.frame.height) * 0.70, height: (self.frame.height) * 0.70)
            //button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            button.imageEdgeInsets.left = -15
            button.backgroundColor = .clear
            button.tintColor = AppColors.primaryBlue
            button.addTarget(self, action: #selector(didTapBtnPasswordToggel), for: .touchUpInside)
            return button
        }()
        self.rightView = passwordToggelButton
        self.rightViewMode = .whileEditing
        self.isSecureTextEntry = true
    }
    @objc private func didTapBtnPasswordToggel(_ sender:UIButton){
        UIView.transition(
            with: (sender),
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                guard let `self` = self else {
                    return
                }
                sender.isSelected.toggle()
                self.isSecureTextEntry.toggle()
            })
    }
    
    
    func setPasswordToggle(normalImage icon1: UIImage, selectedImage icon2: UIImage) {
        let btnView = UIButton(frame: CGRect(x: 0, y: 0,
                                             width: ((self.frame.height) * 0.70),
                                             height: ((self.frame.height) * 0.70)))
        btnView.setImage(icon1, for: .normal)
        btnView.setImage(icon2, for: .selected)
        btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
        self.rightViewMode = .whileEditing
        self.rightView = btnView
        btnView.tag = 10101
        btnView.addTarget(self, action: #selector(btnEyeAction(_:)), for: .touchUpInside)
        isSecureTextEntry = true
    }
    
    @objc private func btnEyeAction(_ sender: UIButton) {
        self.isSecureTextEntry = sender.isSelected
        //sender.isSelected = !sender.isSelected
        UIView.transition(
            with: (sender),
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                guard let `self` = self else {
                    return
                }
                guard sender === self.rightView?.viewWithTag(10101) as? UIButton else {
                    return
                }
                sender.isSelected = !sender.isSelected
            })
    }
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}



extension UIImageView{
    func downLoadImage(url: String, placeHolderImage img: UIImage = UIImage(systemName: "photo")!) {
        if url.isEmpty { /*print("download URL is empty");*/ return }
        let indicator:UIActivityIndicatorView = {
            let activityInd = UIActivityIndicatorView(style: .white)
            activityInd.translatesAutoresizingMaskIntoConstraints = false
            activityInd.color = .gray
            activityInd.startAnimating()
            activityInd.hidesWhenStopped = true
            return activityInd
        }()
        self.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.image = img
        self.tag = 333
        if !(url.isEmpty) {
            if let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let _url = URL(string: urlString){
                
                self.af.setImage(withURL: _url, placeholderImage: img, completion: {(response) in
                    if case .success(let image) = response.result {
                        //print("image downloaded: \(image)")
                        self.image = image
                        self.tag = 0
                        indicator.stopAnimating()
                        indicator.removeFromSuperview()
                    }
                })
                
            }else{
                self.tag = 0
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    
}
