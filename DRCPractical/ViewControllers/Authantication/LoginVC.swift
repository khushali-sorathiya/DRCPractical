//
//  LoginVC.swift
//  DRCPractical
//
//  Created by Akash Chaudhary on 01/07/23.
//
import UIKit

class LoginVC: BaseViewController {
    
    //MARK: Outlet
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var txtEmail: TextField!
    @IBOutlet var txtPassword: TextField!
    @IBOutlet var btnLogin: MainButton!
    
    var isFrom = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationBar.onTappedBack = {
            self.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    static var storyboardInstance:LoginVC {
        return StoryBoard.main.instantiateViewController(withIdentifier: LoginVC.identifier) as! LoginVC
    }
    
    //MARK: IBAction
    @IBAction func btnLoginAction(_ sender: Any) {
        if checkValidation() {
            loginAPICall()
        }
    }
    
    //MARK: CheckValidation
    func checkValidation() -> Bool {
        if (txtEmail.text?.isBlank)! {
            self.showAlertWithBlock(title: "Alert", message: "Please enter E-mail address", buttonTitle: "OK") {
                self.txtEmail.becomeFirstResponder()
            }
            return false
        }else if !txtEmail.text?.isValidEmail() {
            self.showAlertWithBlock(title: "Alert", message: "Please enter valid E-Mail address", buttonTitle: "OK") {
                self.txtEmail.becomeFirstResponder()
            }
            return false
        }
        else if (txtPassword.text?.isBlank)! {
            self.showAlertWithBlock(title: "Alert", message: "Please enter password", buttonTitle: "OK") {
                self.txtPassword.becomeFirstResponder()
            }
            return false
        }
        else{
            self.view.endEditing(true)
            return true
        }
        
    }
    
    //MARK: API call
    func loginAPICall() {
      
    }
    
   
    
}

//MARK: Textfield Delegate
extension LoginVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isBlank {
            return true
        }else if textField == txtEmail {
            return false
        }else if textField == txtPassword, txtPassword.text!.count >= 8 {
            return false
        }
        return true
    }
}
