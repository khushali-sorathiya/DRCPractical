//
//  SignupVC.swift
//  DRCPractical
//
//  Created by Akash Chaudhary on 01/07/23.
//

import UIKit
import CoreData


class SignupVC: UIViewController {
    
    //MARK: Outlet
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var txtName: TextField!
    @IBOutlet var txtPassword: TextField!
    @IBOutlet var txtRepeatPassword: TextField!
    @IBOutlet var txtContact: TextField!
    @IBOutlet var txtEmail: TextField!
    @IBOutlet weak var btnRegister: MainButton!
    
    @IBOutlet weak var btnBack: UIButton!{
        didSet{
            btnBack.setTitle("", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    static var storyboardInstance:SignupVC {
        return StoryBoard.main.instantiateViewController(withIdentifier: SignupVC.identifier) as! SignupVC
    }
    
    
    //MARK: IBAction
    @IBAction func btnregisterAction(_ sender: UIButton) {
        if checkValidation() {
            saveUserData()
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK: Check Validation
    func checkValidation() -> Bool {
        if (txtName.text?.isBlank)! {
            self.showAlertWithBlock(title: "Alert", message: "Please Enter name", buttonTitle: "OK") {
                self.txtName.becomeFirstResponder()
            }
            return false
        }
        else if (txtEmail.text?.isBlank)! {
            self.showAlertWithBlock(title: "Alert", message: "Please enter E-mail address", buttonTitle: "OK") {
                self.txtEmail.becomeFirstResponder()
            }
            return false
        }
        else if !txtEmail.text!.isValidEmail() {
            self.showAlertWithBlock(title: "Alert", message: "Please Enter valid E-mail address", buttonTitle: "OK") {
                self.txtEmail.becomeFirstResponder()
            }
            return false
        }
        else if (txtContact.text?.isBlank)! {
            self.showAlertWithBlock(title: "Alert", message: "Please Enter contact number", buttonTitle: "OK") {
                self.txtContact.becomeFirstResponder()
            }
            return false
        }
        else if !txtContact.text!.isValidPhoneNo {
            self.showAlertWithBlock(title: "Alert", message: "Please enter valid contact number", buttonTitle: "OK") {
                self.txtContact.becomeFirstResponder()
            }
            return false
        }
        else if (txtPassword.text?.isBlank)! {
            self.showAlertWithBlock(title: "Alert", message: "Please enter password", buttonTitle: "OK") {
                self.txtPassword.becomeFirstResponder()
            }
            return false
        }else if txtPassword.text!.count > 8 {
            self.showAlertWithBlock(title: "Alert", message: "Password must contain 8 charactors", buttonTitle: "OK") {
                self.txtPassword.becomeFirstResponder()
            }
            return false
        }
        else if (txtRepeatPassword.text?.isBlank)! {
            self.showAlertWithBlock(title: "Alert", message: "Please enter repeat password", buttonTitle: "OK") {
                self.txtRepeatPassword.becomeFirstResponder()
            }
            return false
        }
        else if txtRepeatPassword.text != txtPassword.text {
            self.showAlertWithBlock(title: "Alert", message: "Password don't match", buttonTitle: "OK") {
                self.txtRepeatPassword.becomeFirstResponder()
            }
            return false
        }
        else{
            self.view.endEditing(true)
            return true
        }
    }
    
    //MARK: data save on core data
    
    func saveUserData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.propertiesToFetch = ["id"]
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            let maxID = results?.first?.value(forKey: "id") as? Int ?? 0
            let newID = maxID + 1
            
            guard let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext) else {
                return
            }
            
            let user = NSManagedObject(entity: entity, insertInto: managedContext)
            user.setValue(newID, forKey: "id")
            user.setValue(txtName.text!, forKey: "name")
            user.setValue(txtEmail.text!, forKey: "email")
            user.setValue(txtContact.text!, forKey: "contact")
            user.setValue(txtPassword.text, forKey: "password")
            
            do {
                try managedContext.save()
                print("User data saved successfully.")
                getUserData()
            } catch let error as NSError {
                print("Failed to save user data. Error: \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Error fetching max ID. Error: \(error), \(error.userInfo)")
        }
    }
    
    func getUserData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let emailPredicate = NSPredicate(format: "email == %@", txtEmail.text!)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [emailPredicate])
        
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
            self.setHomeRootViewController()
        } catch let error as NSError {
            print("Error retrieving user data. Error: \(error), \(error.userInfo)")
        }
    }
    
}


//MARK: TextField delegate
extension SignupVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isBlank {
            return true
        }else if textField == txtName, txtName.text!.count >= 16 {
            return false
        }else if textField == txtPassword, txtPassword.text!.count >= 8 {
            return false
        }else if textField == txtRepeatPassword, txtRepeatPassword.text!.count >= 8 {
            return false
        }else if textField == txtContact, txtContact.text!.count >= 25 {
            return false
        }else if textField == txtContact {
            let allowedCharacters = CharacterSet(charactersIn:"+0123456789()")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }else if textField == txtEmail, txtEmail.text!.count >= 50 {
            return false
        }
        return true
    }
}

