//
//  ProfileView.swift
//  hungr
//
//  Profile screen UI
//

import UIKit

class ProfileView: UIView {
    
    var imageViewProfile: UIImageView!
    var textFieldUsername: UITextField!
    var textViewBio: UITextView!
    var labelMyCookbooks: UILabel!
    var buttonAddCookbook: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        
        setupProfileImage()
        setupUsernameField()
        setupBioTextView()
        setupMyCookbooksLabel()
        setupAddCookbookButton()
        
        initConstraints()
    }
    
    func setupProfileImage() {
        imageViewProfile = UIImageView()
        imageViewProfile.image = UIImage(systemName: "person.circle.fill")
        imageViewProfile.tintColor = .systemGray
        imageViewProfile.contentMode = .scaleAspectFit
        imageViewProfile.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageViewProfile)
    }
    
    func setupUsernameField() {
        textFieldUsername = UITextField()
        textFieldUsername.text = "Username"
        textFieldUsername.font = UIFont.boldSystemFont(ofSize: 20)
        textFieldUsername.textAlignment = .left
        textFieldUsername.borderStyle = .none
        textFieldUsername.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldUsername)
    }
    
    func setupBioTextView() {
        textViewBio = UITextView()
        textViewBio.text = "Share something about yourself!"
        textViewBio.font = UIFont.systemFont(ofSize: 14)
        textViewBio.textColor = .systemGray
        textViewBio.textAlignment = .left
        textViewBio.isScrollEnabled = false
        textViewBio.layer.borderColor = UIColor.systemGray5.cgColor
        textViewBio.layer.borderWidth = 1
        textViewBio.layer.cornerRadius = 8
        textViewBio.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textViewBio.translatesAutoresizingMaskIntoConstraints = false
        textViewBio.delegate = self
        self.addSubview(textViewBio)
    }
    
    func setupMyCookbooksLabel() {
        labelMyCookbooks = UILabel()
        labelMyCookbooks.text = "My Cookbooks"
        labelMyCookbooks.font = UIFont.boldSystemFont(ofSize: 22)
        labelMyCookbooks.textAlignment = .left
        labelMyCookbooks.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelMyCookbooks)
    }
    
    func setupAddCookbookButton() {
        buttonAddCookbook = UIButton(type: .system)
        buttonAddCookbook.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        buttonAddCookbook.tintColor = .systemBlue
        buttonAddCookbook.backgroundColor = .systemGray6
        buttonAddCookbook.layer.cornerRadius = 12
        buttonAddCookbook.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonAddCookbook)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Profile Image - LEFT SIDE
            imageViewProfile.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 24),
            imageViewProfile.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            imageViewProfile.widthAnchor.constraint(equalToConstant: 80),
            imageViewProfile.heightAnchor.constraint(equalToConstant: 80),
            
            // Username Field - TOP RIGHT, NEXT TO PROFILE IMAGE
            textFieldUsername.topAnchor.constraint(equalTo: imageViewProfile.topAnchor),
            textFieldUsername.leadingAnchor.constraint(equalTo: imageViewProfile.trailingAnchor, constant: 16),
            textFieldUsername.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            textFieldUsername.heightAnchor.constraint(equalToConstant: 30),
            
            // Bio Text View - BELOW USERNAME, SAME WIDTH AS PROFILE IMAGE HEIGHT
            textViewBio.topAnchor.constraint(equalTo: textFieldUsername.bottomAnchor, constant: 8),
            textViewBio.leadingAnchor.constraint(equalTo: imageViewProfile.trailingAnchor, constant: 16),
            textViewBio.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            textViewBio.bottomAnchor.constraint(lessThanOrEqualTo: imageViewProfile.bottomAnchor),
            
            // My Cookbooks Label - BELOW PROFILE IMAGE
            labelMyCookbooks.topAnchor.constraint(equalTo: imageViewProfile.bottomAnchor, constant: 40),
            labelMyCookbooks.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            labelMyCookbooks.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            
            // Add Cookbook Button - BELOW LABEL
            buttonAddCookbook.topAnchor.constraint(equalTo: labelMyCookbooks.bottomAnchor, constant: 16),
            buttonAddCookbook.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            buttonAddCookbook.widthAnchor.constraint(equalToConstant: 100),
            buttonAddCookbook.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func updateProfile(name: String, email: String) {
        textFieldUsername.text = name
        // You can use email elsewhere or store it
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITextViewDelegate
extension ProfileView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        // Max character limit: 150 characters
        return updatedText.count <= 150
    }
}
