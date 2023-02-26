//
//  ViewController.swift
//  PHNAssignment
//
//  Created by Admin on 23/02/23.
//

import UIKit

class PHNLogInViewController: UITableViewController {
    
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonLogIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
    }
    
    private func configureTextField() {
        textFieldUserName.delegate = self
        textFieldPassword.delegate = self
    }
   
    @IBAction func clickedLogInButton(_ sender: Any) {
        logInUsingSavedCredentials()
    }
    
    private func logInUsingSavedCredentials() {
        
        var existingUser = false
        
        if let existingUserData = PHNKeyChain.shared.load(key: "Users"),
           let decodedArray = NSKeyedUnarchiver.unarchiveObject(with: existingUserData) as? [Any] {
            for index in 0..<decodedArray.count {
                if let enteredName = textFieldUserName.text,
                   let enteredPassword = textFieldPassword.text,
                   let user = decodedArray[index] as? [String] {
                    //Username based check
                    if enteredName == user[0] as? String &&
                        enteredPassword == user[2] as? String {
                        existingUser = true
                        break
                    }
                    //Email based check
                    else if enteredName == user[1] as? String && enteredPassword == user[2] as? String {
                        existingUser = true
                        break
                    }
                }
            }
        }
        
        if existingUser {
            navigateToHome()
        } else {
            let alert = UIAlertController(title: "Error", message: "User does not exist or Invalid credentials", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func navigateToHome() {
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let homeTabVC = sb.instantiateViewController(withIdentifier: "PHNHomeNavigation" ) //Best practie is to use string for constants
        UIApplication.shared.keyWindow?.rootViewController = homeTabVC
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
}

extension PHNLogInViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldUserName.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        return true
    }
}

//https://stackoverflow.com/questions/37539997/save-and-load-from-keychain-swift
//https://stackoverflow.com/a/45281186/19544109

