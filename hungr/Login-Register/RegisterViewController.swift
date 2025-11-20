//
//  RegisterViewController.swift
//  hungr
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
        if validateInputs() {
            showActivityIndicator()
            registerNewUser()
        }
    }
    
    @objc func onLoginTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func navigateToMainScreen() {
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Input Validation Extension
extension RegisterViewController {
    
    func validateInputs() -> Bool {
        guard let name = registerView.textFieldName.text, !name.isEmpty,
              let email = registerView.textFieldEmail.text, !email.isEmpty,
              let password = registerView.textFieldPassword.text, !password.isEmpty,
              let repeatPassword = registerView.textFieldRepeatPassword.text, !repeatPassword.isEmpty
        else {
            showAlert(title: "Missing Information", message: "Please fill in all fields")
            return false
        }
        
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showAlert(title: "Invalid Name", message: "Please enter a valid name")
            return false
        }
        
        if !isValidEmail(email) {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address")
            return false
        }
        
        if password != repeatPassword {
            showAlert(title: "Password Mismatch", message: "Passwords do not match. Please try again")
            return false
        }
        
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
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
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
            DispatchQueue.main.async {
                self.hideActivityIndicator()
            }
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            // Always run UI updates on main thread
            DispatchQueue.main.async {
                if let error = error {
                    self.hideActivityIndicator()
                    self.showAlert(title: "Registration Failed", message: error.localizedDescription)
                    return
                }
                
                guard let user = result?.user else {
                    self.hideActivityIndicator()
                    self.showAlert(title: "Error", message: "Failed to create user")
                    return
                }
                
                // Update display name (don't wait for it)
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                    if let error = error {
                        print("Error updating profile: \(error)")
                    }
                }
                
                // Save to Firestore
                self.saveUserToFirestore(uid: user.uid, name: name, email: email)
            }
        }
    }
    
    func saveUserToFirestore(uid: String, name: String, email: String) {
        let userData: [String: Any] = [
            "name": name,
            "email": email,
            "uid": uid,
            "createdAt": Timestamp(date: Date())
        ]
        
        database.collection("users").document(uid).setData(userData) { [weak self] error in
            guard let self = self else { return }
            
            // CRITICAL: Always hide spinner on main thread
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                
                if let error = error {
                    self.showAlert(title: "Error", message: "Failed to save user data: \(error.localizedDescription)")
                    return
                }
                
                // Success!
                self.showAlert(title: "Success", message: "Account created successfully!") {
                    self.navigateToMainScreen()
                }
            }
        }
    }
}
