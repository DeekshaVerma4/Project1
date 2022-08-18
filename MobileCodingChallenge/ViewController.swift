//  ViewController.swift
//  MobileCodingChallenge
//  Created by Deeksha Verma on 16/08/22.

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 8.0
    }
    
    
    
    @IBAction func signUpAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        present(nextViewController, animated: true)
    }
    
    @IBAction func signInAction(_ sender: Any) {
        self.view.endEditing(true)
        if emailValidation() {
            if passwordValidation() {
                var emailFound = false
                let userData = DatabaseManager.getInstance().getAllUsers()
                for userDatum in userData {
                    if userDatum.email == emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) {
                        emailFound = true
                        if userDatum.password == passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) {
                            self.view.makeToast("Login Successful.")
                            UserDefaults.standard.set(true, forKey: "login")
                            UserDefaults.standard.synchronize()
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UsersViewController") as! UsersViewController
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.navigationController1?.pushViewController(nextViewController, animated: true)
                        } else {
                            self.view.makeToast("Invalid Password.")
                        }
                    }
                }
                if !emailFound {
                    self.view.makeToast("User not registered.")
                }
            }
        }
    }
    
    //MARK: Validations
    /// This method is used to validate email address.
    /// - Returns: if validations are correct then true else false.
    func passwordValidation() -> Bool {
        if passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            DispatchQueue.main.async {
                self.view.makeToast("Enter Password.")
            }
            return false
        }
        return true
    }
    
    //MARK: Validations
    /// This method is used to validate email address.
    /// - Returns: if validations are correct then true else false.
    func emailValidation() -> Bool {
        if emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            DispatchQueue.main.async {
                self.view.makeToast("Enter Your Email ID.")
            }
            return false
        } else {
            if isValidEmail(emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) {
                return true
            } else {
                DispatchQueue.main.async {
                    self.view.makeToast("Enter Valid Email ID.")
                }
                return false
            }
        }
    }
    
    // MARK: Valid Email
    /// This method is used to validate correct emailID.
    /// - Parameter emailID: emailID to be verified
    /// - Returns: true if emailID is correct else false.
    func isValidEmail(_ emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let email = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = email.evaluate(with: emailID)
        return result
    }
}


extension ViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

