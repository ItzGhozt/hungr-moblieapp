//
//  RegisterView.swift
//  assignment8
//
//  Created by Isabel Yeow on 11/7/25.
//

import UIKit

class RegisterView: UIView {
    
    var labelTitle: UILabel!
    var textFieldName: UITextField!
    var textFieldEmail: UITextField!
    var textFieldPassword: UITextField!
    var textFieldRepeatPassword: UITextField!
    var buttonRegister: UIButton!
    var labelAlreadyHaveAccount: UILabel!
    var buttonLogin: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        
        setupLabelTitle()
        setupTextFieldName()
        setupTextFieldEmail()
        setupTextFieldPassword()
        setupTextFieldRepeatPassword()
        setupButtonRegister()
        setupLabelAlreadyHaveAccount()
        setupButtonLogin()
        
        initConstraints()
    }
    
    func setupLabelTitle() {
        labelTitle = UILabel()
        labelTitle.text = "Create Account"
        labelTitle.font = UIFont.boldSystemFont(ofSize: 32)
        labelTitle.textAlignment = .center
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelTitle)
    }
    
    func setupTextFieldName() {
        textFieldName = UITextField()
        textFieldName.placeholder = "Full Name"
        textFieldName.borderStyle = .roundedRect
        textFieldName.autocapitalizationType = .words
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldName)
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
    
    func setupTextFieldRepeatPassword() {
        textFieldRepeatPassword = UITextField()
        textFieldRepeatPassword.placeholder = "Repeat Password"
        textFieldRepeatPassword.borderStyle = .roundedRect
        textFieldRepeatPassword.isSecureTextEntry = true
        textFieldRepeatPassword.autocapitalizationType = .none
        textFieldRepeatPassword.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldRepeatPassword)
    }
    
    func setupButtonRegister() {
        buttonRegister = UIButton(type: .system)
        buttonRegister.setTitle("Register", for: .normal)
        buttonRegister.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        buttonRegister.backgroundColor = .systemBlue
        buttonRegister.setTitleColor(.white, for: .normal)
        buttonRegister.layer.cornerRadius = 8
        buttonRegister.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonRegister)
    }
    
    func setupLabelAlreadyHaveAccount() {
        labelAlreadyHaveAccount = UILabel()
        labelAlreadyHaveAccount.text = "Already have an account?"
        labelAlreadyHaveAccount.font = UIFont.systemFont(ofSize: 14)
        labelAlreadyHaveAccount.textColor = .systemGray
        labelAlreadyHaveAccount.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelAlreadyHaveAccount)
    }
    
    func setupButtonLogin() {
        buttonLogin = UIButton(type: .system)
        buttonLogin.setTitle("Login", for: .normal)
        buttonLogin.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        buttonLogin.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonLogin)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Title Label
            labelTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32),
            labelTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            labelTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            // Name TextField
            textFieldName.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 48),
            textFieldName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            textFieldName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            textFieldName.heightAnchor.constraint(equalToConstant: 48),
            
            // Email TextField
            textFieldEmail.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 16),
            textFieldEmail.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            textFieldEmail.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            textFieldEmail.heightAnchor.constraint(equalToConstant: 48),
            
            // Password TextField
            textFieldPassword.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 16),
            textFieldPassword.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            textFieldPassword.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            textFieldPassword.heightAnchor.constraint(equalToConstant: 48),
            
            // Repeat Password TextField
            textFieldRepeatPassword.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 16),
            textFieldRepeatPassword.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            textFieldRepeatPassword.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            textFieldRepeatPassword.heightAnchor.constraint(equalToConstant: 48),
            
            // Register Button
            buttonRegister.topAnchor.constraint(equalTo: textFieldRepeatPassword.bottomAnchor, constant: 32),
            buttonRegister.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            buttonRegister.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            buttonRegister.heightAnchor.constraint(equalToConstant: 48),
            
            // Already have account label
            labelAlreadyHaveAccount.topAnchor.constraint(equalTo: buttonRegister.bottomAnchor, constant: 24),
            labelAlreadyHaveAccount.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -4),
            
            // Login button
            buttonLogin.centerYAnchor.constraint(equalTo: labelAlreadyHaveAccount.centerYAnchor),
            buttonLogin.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 4),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
