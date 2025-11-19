//
//  RegisterViewController.swift
//  assignment8
//
//  Created by Isabel Yeow on 11/7/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    
    let registerView = RegisterView()
    
    let childProgressView = ProgressSpinnerViewController()
    
    let database = Firestore.firestore()
    
    override func loadView() {
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Register"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Hide keyboard when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // Add button targets
        registerView.buttonRegister.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
        registerView.buttonLogin.addTarget(self, action: #selector(onLoginTapped), for: .touchUpInside)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func onRegisterTapped() {
        // Validate inputs first
        if validateInputs() {
            showActivityIndicator()
            registerNewUser()
        }
    }
    
    @objc func onLoginTapped() {
        // Navigate to login screen
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Input Validation Extension
extension RegisterViewController {
    
    func validateInputs() -> Bool {
        // Get all input values
        guard let name = registerView.textFieldName.text, !name.isEmpty,
              let email = registerView.textFieldEmail.text, !email.isEmpty,
              let password = registerView.textFieldPassword.text, !password.isEmpty,
              let repeatPassword = registerView.textFieldRepeatPassword.text, !repeatPassword.isEmpty
        else {
            showAlert(title: "Missing Information", message: "Please fill in all fields")
            return false
        }
        
        // Validate name
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showAlert(title: "Invalid Name", message: "Please enter a valid name")
            return false
        }
        
        // Validate email format
        if !isValidEmail(email) {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address")
            return false
        }
        
        // Check password match
        if password != repeatPassword {
            showAlert(title: "Password Mismatch", message: "Passwords do not match. Please try again")
            return false
        }
        
        // Check password strength (Firebase requires at least 6 characters)
        if password.count < 6 {
            showAlert(title: "Weak Password", message: "Password must be at least 6 characters long")
            return false
        }
        
        return true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Progress Indicator Extension
extension RegisterViewController: ProgressSpinnerDelegate {
    
    func showActivityIndicator() {
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }
    
    func hideActivityIndicator() {
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
}

// MARK: - Firebase Manager Extension
extension RegisterViewController {
    
    func registerNewUser() {
        guard let name = registerView.textFieldName.text,
              let email = registerView.textFieldEmail.text,
              let password = registerView.textFieldPassword.text else {
            hideActivityIndicator()
            return
        }
        
        // Create user in Firebase Auth
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.hideActivityIndicator()
                self?.showAlert(title: "Registration Failed", message: error.localizedDescription)
                return
            }
            
            guard let user = result?.user else {
                self?.hideActivityIndicator()
                self?.showAlert(title: "Error", message: "Failed to create user")
                return
            }
            
            // Update user profile with name
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                if let error = error {
                    print("Error updating profile: \(error)")
                }
            }
            
            // Save user to Firestore
            self?.saveUserToFirestore(uid: user.uid, name: name, email: email)
        }
    }
    
    func saveUserToFirestore(uid: String, name: String, email: String) {
        // Create User object
        let newUser = User(uid: uid, name: name, email: email)
        
        // Save to Firestore
        database.collection("users").document(uid).setData(newUser.toDictionary()) { [weak self] error in
            self?.hideActivityIndicator()
            
            if let error = error {
                self?.showAlert(title: "Error", message: "Failed to save user data: \(error.localizedDescription)")
                return
            }
            
            // Success - Navigate back to login or main screen
            self?.showAlert(title: "Success", message: "Account created successfully! Welcome!") {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - Helper to add completion handler to alert
extension RegisterViewController {
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}
