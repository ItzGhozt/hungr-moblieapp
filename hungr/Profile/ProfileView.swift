//
//  ProfileView.swift
//  hungr
//
//  Profile screen UI
//

import UIKit

class ProfileView: UIView {
    
    var imageViewProfile: UIImageView!
    var labelName: UILabel!
    var labelEmail: UILabel!
    var stackViewInfo: UIStackView!
    var buttonCookbook: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        
        setupStackView()
        setupProfileImage()
        setupCookbookButton()
        
        initConstraints()
    }
    
    func setupStackView() {
        labelName = UILabel()
        labelName.text = "Loading..."
        labelName.font = UIFont.boldSystemFont(ofSize: 28)
        labelName.textAlignment = .center
        labelName.translatesAutoresizingMaskIntoConstraints = false
        
        labelEmail = UILabel()
        labelEmail.text = "Loading..."
        labelEmail.font = UIFont.systemFont(ofSize: 16)
        labelEmail.textColor = .systemGray
        labelEmail.textAlignment = .center
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        
        stackViewInfo = UIStackView(arrangedSubviews: [labelName, labelEmail])
        stackViewInfo.axis = .vertical
        stackViewInfo.spacing = 8
        stackViewInfo.alignment = .center
        stackViewInfo.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackViewInfo)
    }
    
    func setupProfileImage() {
        imageViewProfile = UIImageView()
        imageViewProfile.image = UIImage(systemName: "person.circle.fill")
        imageViewProfile.tintColor = .systemGray
        imageViewProfile.contentMode = .scaleAspectFit
        imageViewProfile.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageViewProfile)
    }
    
    func setupCookbookButton() {
        buttonCookbook = UIButton(type: .system)
        buttonCookbook.setTitle("My Cookbook", for: .normal)
        buttonCookbook.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        buttonCookbook.backgroundColor = .systemBlue
        buttonCookbook.setTitleColor(.white, for: .normal)
        buttonCookbook.layer.cornerRadius = 12
        buttonCookbook.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonCookbook)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Stack View with Name and Email - AT TOP
            stackViewInfo.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 24),
            stackViewInfo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            stackViewInfo.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            
            // Profile Image - BELOW NAME/EMAIL
            imageViewProfile.topAnchor.constraint(equalTo: stackViewInfo.bottomAnchor, constant: 32),
            imageViewProfile.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageViewProfile.widthAnchor.constraint(equalToConstant: 120),
            imageViewProfile.heightAnchor.constraint(equalToConstant: 120),
            
            // Cookbook Button - BELOW PROFILE IMAGE
            buttonCookbook.topAnchor.constraint(equalTo: imageViewProfile.bottomAnchor, constant: 48),
            buttonCookbook.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            buttonCookbook.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            buttonCookbook.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    func updateProfile(name: String, email: String) {
        labelName.text = name
        labelEmail.text = email
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
