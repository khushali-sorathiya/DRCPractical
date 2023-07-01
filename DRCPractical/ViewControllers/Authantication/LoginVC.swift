//
//  LoginVC.swift
//  DRCPractical
//
//  Created by Akash Chaudhary on 01/07/23.
//

import UIKit
import CoreData

class LoginVC: UIViewController {
    
    @IBOutlet weak var txtemail: TextField!
    @IBOutlet weak var txtpassword: TextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static var storyboardInstance:LoginVC {
        return StoryBoard.main.instantiateViewController(withIdentifier: LoginVC.identifier) as! LoginVC
    }
    
    @IBAction func btnSignInAction(_ sender: Any) {
        if checkValidation() {
            if checkUserCredentials() {
                self.setHomeRootViewController()
            }
        }
    }
    
    
    @IBAction func btnSignUPAction(_ sender: Any) {
        self.navigationController?.pushViewController(SignupVC.storyboardInstance, animated: false)
    }
    
    //MARK: CheckValidation
    func checkValidation() -> Bool {
        if (txtemail.text?.isBlank)! {
            self.showAlertWithBlock(title: "Alert", message: "Please enter E-mail address", buttonTitle: "OK") {
                self.txtemail.becomeFirstResponder()
            }
            return false
        }else if !(txtemail.text?.isValidEmail())! {
            self.showAlertWithBlock(title: "Alert", message: "Please enter valid E-Mail address", buttonTitle: "OK") {
                self.txtemail.becomeFirstResponder()
            }
            return false
        }
        else if (txtpassword.text?.isBlank)! {
            self.showAlertWithBlock(title: "Alert", message: "Please enter password", buttonTitle: "OK") {
                self.txtpassword.becomeFirstResponder()
            }
            return false
        }
        else{
            self.view.endEditing(true)
            return true
        }
        
    }
    
    //MARK: Data fatch form core data
    
    func checkUserCredentials() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let emailPredicate = NSPredicate(format: "email == %@", txtemail.text!)
        let passwordPredicate = NSPredicate(format: "password == %@", txtpassword.text!)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [emailPredicate, passwordPredicate])
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for case let user as NSManagedObject in results {
                        if let name = user.value(forKey: "name") as? String,
                           let id = user.value(forKey: "id") as? Int {
                            print("Name: \(name), ID: \(id)")
                            UserDefaults.standard.set(id, forKey: "user_id")
                            UserDefaults.standard.synchronize()
                        }
                    }
            let count = try managedContext.count(for: fetchRequest)
            return results.count > 0 ? true : false
        } catch let error as NSError {
            print("Error checking user credentials. Error: \(error), \(error.userInfo)")
            return false
        }
    }

}


//MARK: Textfield Delegate
extension LoginVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isBlank {
            return true
        }else if textField == txtemail {
            return false
        }else if textField == txtpassword, txtpassword.text!.count >= 8 {
            return false
        }
        return true
    }
}
