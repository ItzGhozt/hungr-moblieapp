//
//  LoginViewController.swift
//  WA8
//
//  Handles user login
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    let loginView = LoginView()
    
    let childProgressView = ProgressSpinnerViewController()
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Hide back button on login screen
        navigationItem.hidesBackButton = true
        
        // Hide keyboard when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // Add button targets
        loginView.buttonLogin.addTarget(self, action: #selector(onLoginTapped), for: .touchUpInside)
        loginView.buttonRegister.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Show navigation bar on login screen
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        // If already logged in, go to main screen
        if Auth.auth().currentUser != nil {
            navigateToMainScreen()
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func onLoginTapped() {
        if validateInputs() {
            showActivityIndicator()
            loginUser()
        }
    }
    
    @objc func onRegisterTapped() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func navigateToMainScreen() {
        let mainVC = MainViewController()
        navigationController?.setViewControllers([mainVC], animated: true)
    }
}

// MARK: - Input Validation Extension
extension LoginViewController {
    
    func validateInputs() -> Bool {
        guard let email = loginView.textFieldEmail.text, !email.isEmpty,
              let password = loginView.textFieldPassword.text, !password.isEmpty else {
            showAlert(title: "Missing Information", message: "Please enter both email and password")
            return false
        }
        
        // Validate email format
        if !isValidEmail(email) {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address")
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
extension LoginViewController: ProgressSpinnerDelegate {
    
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
extension LoginViewController {
    
    func loginUser() {
        guard let email = loginView.textFieldEmail.text,
              let password = loginView.textFieldPassword.text else {
            hideActivityIndicator()
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            self?.hideActivityIndicator()
            
            if let error = error {
                self?.showAlert(title: "Login Failed", message: "this user is not register, please make a new account")
                return
            }
            
            guard let _ = result?.user else {
                self?.showAlert(title: "Error", message: "Failed to login")
                return
            }
            
            // Success - Navigate to main screen
            self?.navigateToMainScreen()
        }
    }
}
