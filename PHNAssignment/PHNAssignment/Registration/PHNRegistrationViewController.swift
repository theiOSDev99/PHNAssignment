//
//  RegistrationViewController.swift
//  PHNAssignment
//
//  Created by Admin on 23/02/23.
//

import Foundation
import UIKit

class PHNRegistrationViewController: UITableViewController {
    
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var labelErrorMessageUserName: UILabel!
    @IBOutlet weak var textFieldEmailId: UITextField!
    @IBOutlet weak var labelErrorMessageEmail: UILabel!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var labelErrorMessagePassword: UILabel!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    @IBOutlet weak var labelErrorMessageConfirmPassword: UILabel!
    @IBOutlet weak var buttonRegister: UIButton!
    let viewModel = PHNRegisterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonRegister.isEnabled = false
        configureViewModelBinding()
        configureTextField()
        configureErrorLabels()
    }
    
    private func configureViewModelBinding() {
        viewModel.userName.addObservale { userName in
            self.validateEntries()
        }
        
        viewModel.emailId.addObservale { email in
            self.validateEntries()
        }
        
        viewModel.password.addObservale { password in
            self.validateEntries()
        }
        
        viewModel.confirmPassword.addObservale { confirmPassword in
            self.validateEntries()
        }
    }

    private func configureTextField() {
        textFieldUserName.delegate = self
        textFieldEmailId.delegate = self
        textFieldPassword.delegate = self
        textFieldConfirmPassword.delegate = self
        
        textFieldUserName.addTarget(self, action: #selector(PHNRegistrationViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        textFieldEmailId.addTarget(self, action: #selector(PHNRegistrationViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        textFieldPassword.addTarget(self, action: #selector(PHNRegistrationViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
        textFieldConfirmPassword.addTarget(self, action: #selector(PHNRegistrationViewController.textFieldDidChange(_:)),
                                  for: .editingChanged)
    }
    
    private func configureErrorLabels() {
        labelErrorMessageUserName.text = "Username should be min 4 char"
        labelErrorMessageUserName.isHidden = true
        
        labelErrorMessageEmail.text = "Invalid email format"
        labelErrorMessageEmail.isHidden = true

        labelErrorMessagePassword.text = "Password should be aplhanumeric & 4-8 char"
        labelErrorMessagePassword.isHidden = true

        labelErrorMessageConfirmPassword.text = "Password does not match"
        labelErrorMessageConfirmPassword.isHidden = true
    }

    @IBAction func clickedRegisterButton(_ sender: Any) {
        saveCredentialsInKeychain()
        navigateToLogin()
    }
    
    private func navigateToLogin() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let homeTabVC = sb.instantiateViewController(withIdentifier: "PHNLogInViewController" ) //Best practie is to use string for constants
        UIApplication.shared.keyWindow?.rootViewController = homeTabVC
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    
    private func saveCredentialsInKeychain() {
        var newUserList = [Any]()
        if let existingUserData = PHNKeyChain.shared.load(key: "Users"),
            let decodedArray = NSKeyedUnarchiver.unarchiveObject(with: existingUserData) as? [Any] {
            newUserList.append(contentsOf: decodedArray)
        }
        
        if let saveUserName = textFieldUserName.text,
           let saveEmail = textFieldEmailId.text,
           let savePassword = textFieldPassword.text {
            let newUser = [saveUserName, saveEmail, savePassword]
            newUserList.append(newUser)
        }
    
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: [newUserList])
        PHNKeyChain.shared.save(key: "Users", data: encodedData)
    }
    
    private func validateEntries() {
        let validUserName = viewModel.validateUserName()
        labelErrorMessageUserName.isHidden = validUserName ? true : false
        
        let validEmail = viewModel.validateEmail()
        labelErrorMessageEmail.isHidden = validEmail ? true : false
        
        let validPassword = viewModel.validatePassword()
        labelErrorMessagePassword.isHidden = validPassword ? true : false
        
        let validConfirmPassword =  viewModel.validateConfirmPassward()
        labelErrorMessageConfirmPassword.isHidden = validConfirmPassword ?  true : false
        
        if validUserName && validEmail && validPassword && validConfirmPassword  {
            buttonRegister.isEnabled = true
        } else {
            buttonRegister.isEnabled = false
        }
    }
}

extension PHNRegistrationViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == textFieldUserName {
            viewModel.userName.value = textField.text
        } else if textField == textFieldEmailId {
            viewModel.emailId.value = textField.text
        } else if textField == textFieldPassword {
            viewModel.password.value = textField.text
        } else if textField == textFieldConfirmPassword {
            viewModel.confirmPassword.value = textField.text
        }
    }
}
