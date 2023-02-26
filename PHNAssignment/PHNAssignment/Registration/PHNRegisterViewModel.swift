//
//  PHNRegisterViewModel.swift
//  PHNAssignment
//
//  Created by Admin on 25/02/23.
//

import Foundation

class PHNRegisterViewModel {
    var userName: PHNObservable<String> = PHNObservable(value: "")
    var emailId: PHNObservable<String> = PHNObservable(value: "")
    var password: PHNObservable<String> = PHNObservable(value: "")
    var confirmPassword: PHNObservable<String> = PHNObservable(value: "")
    
    private let validPasswordMinLength = 4
    private let validPasswordMaxLength = 8
    
    func validateUserName() -> Bool {
        var validateUserName = false
        let userNameCount = userName.value?.count ?? 0
        if userNameCount >= validPasswordMinLength && userNameCount <= validPasswordMaxLength {
            validateUserName = true
        }
        return validateUserName
    }
    
    func validateEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let validEmail = emailTest.evaluate(with: emailId.value)
        return validEmail
    }
    
    func validatePassword() -> Bool {
        let passwordRegEx = "[A-Z0-9a-z]{4,8}"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        let validPassword = passwordTest.evaluate(with: password.value)
        return validPassword
    }
    
    func validateConfirmPassward() -> Bool {
        return password.value == confirmPassword.value
    }
}
