//  SignUpViewController.swift
//  MobileCodingChallenge
//  Created by Deeksha Verma on 17/08/22.

import UIKit
import MBProgressHUD

class SignUpViewController: UIViewController {
    @IBOutlet weak var countrySearchBar: UISearchBar!
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var countryListTableView: UITableView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    var countryList: [CountryModel]!
    var selectedCountry: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryView.isHidden = true
        countryListTableView.tableFooterView = UIView()

    }
    
    @IBAction func signUpAction(_ sender: Any) {
        self.view.endEditing(true)
        if userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.view.makeToast("Enter Username.")
            return
        }
        if emailValidation() {
            if passwordValidation() {
                if selectedCountry != nil && !selectedCountry.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    let modelInfo = SignupModel(username: userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), email: emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), country: selectedCountry.trimmingCharacters(in: .whitespacesAndNewlines), password: passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                    let isSave = DatabaseManager.getInstance().saveData(modelInfo)
                    print(isSave)
                    if isSave {
                        dismiss(animated: true)
                    } else {
                        self.view.makeToast("Try again after sometime.")
                    }
                }else {
                    DispatchQueue.main.async {
                        self.view.makeToast("Select Country")
                        return
                    }
                }
            }
        }
    }
    
    @IBAction func hideCountryList(_ sender: Any) {
        self.countryView.isHidden = true
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
    
    @IBAction func openCountryList(_ sender: Any) {
        self.view.endEditing(true)
        countrySearchBar.text = ""
        if countryList == nil || countryList!.count == 0 {
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
            getCountryList()
        } else {
            countryListTableView.reloadData()
            countryView.isHidden = false
        }
    }
    
    func getCountryList() {
        var url = ""
        if countrySearchBar.text!.isEmpty {
            url = "https://restcountries.com/v3.1/all"
        } else {
            countryList.removeAll()
            url = "https://restcountries.com/v3.1/name/\(countrySearchBar.text!)"
        }
        network.getData(url, callBack: { (data, error) -> (Void) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            do  {
                let responseData = try JSONDecoder().decode([CountryModel].self, from: data ?? Data())
                self.countryList = responseData
                if self.countryList != nil && self.countryList!.count > 0 {
                    DispatchQueue.main.async {
                        self.countryView.isHidden = false
                        self.countryListTableView.reloadData()
                    }
                }
            } catch { }
        })
    }

}

extension SignUpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell")!
        let countryNameLabel = cell.viewWithTag(1) as! UILabel
        countryNameLabel.text = countryList?[indexPath.row].name?.common ?? ""
        let checkBox = cell.viewWithTag(2) as! UIButton
        checkBox.isHidden = true
        if selectedCountry != nil && selectedCountry == countryNameLabel.text! {
            checkBox.isHidden = false
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCountry = countryList?[indexPath.row].name?.common ?? ""
        countryButton.setTitle(selectedCountry, for: .normal)
        if !countrySearchBar.text!.isEmpty {
            countrySearchBar.text = ""
            countryList.removeAll()
        }
        countryView.isHidden = true
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField {
            let str :String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            print(str)
            //            if isValidEmail(str) {
            //                isEmailCorrect.isHidden = false
            //            } else {
            //                isEmailCorrect.isHidden = true
            //            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField == userNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension SignUpViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let when = DispatchTime.now() + 0.02
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.getCountryList()
        }
    }
}
