//
//  LoginView.swift
//  assignment8
//
//  Created by Isabel Yeow on 11/7/25.
//

import UIKit

class LoginView: UIView {
    
    var labelTitle: UILabel!
    var labelWelcome: UILabel!
    var textFieldEmail: UITextField!
    var textFieldPassword: UITextField!
    var buttonLogin: UIButton!
    var labelNoAccount: UILabel!
    var buttonRegister: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        
        setupLabelTitle()
        setupLabelWelcome()
        setupTextFieldEmail()
        setupTextFieldPassword()
        setupButtonLogin()
        setupLabelNoAccount()
        setupButtonRegister()
        
        initConstraints()
    }
    
    func setupLabelTitle() {
        labelTitle = UILabel()
        labelTitle.text = "Hungr"
        labelTitle.font = UIFont.boldSystemFont(ofSize: 36)
        labelTitle.textAlignment = .center
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelTitle)
    }
    
    func setupLabelWelcome() {
        labelWelcome = UILabel()
        labelWelcome.text = "Welcome"
        labelWelcome.font = UIFont.systemFont(ofSize: 18)
        labelWelcome.textColor = .systemGray
        labelWelcome.textAlignment = .center
        labelWelcome.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelWelcome)
    }
    
    func setupTextFieldEmail() {
        textFieldEmail = UITextField()
        textFieldEmail.placeholder = "Email Address"
        textFieldEmail.borderStyle = .roundedRect
        textFieldEmail.keyboardType = .emailAddress
        textFieldEmail.autocapitalizationType = .none
        textFieldEmail.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldEmail)
    }
    
    func setupTextFieldPassword() {
        textFieldPassword = UITextField()
        textFieldPassword.placeholder = "Password"
        textFieldPassword.borderStyle = .roundedRect
        textFieldPassword.isSecureTextEntry = true
        textFieldPassword.autocapitalizationType = .none
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldPassword)
    }
    
    func setupButtonLogin() {
        buttonLogin = UIButton(type: .system)
        buttonLogin.setTitle("Login", for: .normal)
        buttonLogin.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        buttonLogin.backgroundColor = .systemBlue
        buttonLogin.setTitleColor(.white, for: .normal)
        buttonLogin.layer.cornerRadius = 8
        buttonLogin.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonLogin)
    }
    
    func setupLabelNoAccount() {
        labelNoAccount = UILabel()
        labelNoAccount.text = "Don't have an account?"
        labelNoAccount.font = UIFont.systemFont(ofSize: 14)
        labelNoAccount.textColor = .systemGray
        labelNoAccount.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelNoAccount)
    }
    
    func setupButtonRegister() {
        buttonRegister = UIButton(type: .system)
        buttonRegister.setTitle("Register", for: .normal)
        buttonRegister.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        buttonRegister.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonRegister)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Title Label
            labelTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 60),
            labelTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            labelTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            // Welcome Label
            labelWelcome.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 8),
            labelWelcome.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            labelWelcome.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            labelWelcome.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            // Email TextField
            textFieldEmail.topAnchor.constraint(equalTo: labelWelcome.bottomAnchor, constant: 48),
            textFieldEmail.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            textFieldEmail.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            textFieldEmail.heightAnchor.constraint(equalToConstant: 48),
            
            // Password TextField
            textFieldPassword.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 16),
            textFieldPassword.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            textFieldPassword.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            textFieldPassword.heightAnchor.constraint(equalToConstant: 48),
            
            // Login Button
            buttonLogin.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 32),
            buttonLogin.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            buttonLogin.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            buttonLogin.heightAnchor.constraint(equalToConstant: 48),
            
            // No account label
            labelNoAccount.topAnchor.constraint(equalTo: buttonLogin.bottomAnchor, constant: 24),
            labelNoAccount.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -4),
            
            // Register button
            buttonRegister.centerYAnchor.constraint(equalTo: labelNoAccount.centerYAnchor),
            buttonRegister.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 4),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
