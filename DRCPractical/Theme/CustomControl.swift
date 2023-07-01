//
//  CustomControl.swift
//  DRCPractical
//
//  Created by Khushali on 01/07/23.
//

import Foundation
import UIKit

class TextField: UITextField {

    var isPreventCaret:Bool = false
    var isPreventTextEntry = false
    @IBInspectable var isRequriedFiled : Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = UIFont.systemFont(ofSize: 17) 
        self.textColor = AppColors.appBlack
        self.borderStyle = .none
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.autocapitalizationType = .none
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.loadUI()
        })
  }

    @objc private func loadUI() {
        self.border(side: .bottom, color: AppColors.lightgray, borderWidth: 1)
        self.addClearButton()
        if isRequriedFiled {
            self.setTextFiledAsRequired()
        }
    }
    
    @objc func textFieldDidChange(_ sender: TextField) {
        if isPreventTextEntry{
            sender.isUserInteractionEnabled = false
        }
    }
    
    @objc func textFieldDidEndChange(_ sender: TextField) {
        if isPreventTextEntry{
            sender.isUserInteractionEnabled = true
        }
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return  ( isPreventCaret ? CGRect.zero : super.caretRect(for: position) )
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if isPreventCaret &&
            (action == #selector(UIResponderStandardEditActions.copy(_:)) ||
            action == #selector(UIResponderStandardEditActions.selectAll(_:)) ||
            action == #selector(UIResponderStandardEditActions.paste(_:)) ) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
}

class MainButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitleColor(AppColors.appWhite, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
        layer.cornerRadius = 15
        backgroundColor = AppColors.primaryBlue
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
}

