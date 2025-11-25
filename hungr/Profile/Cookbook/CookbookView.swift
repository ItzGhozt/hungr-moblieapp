//
//  CookbookView.swift
//  hungr
//
//  Cookbook page UI with open book background
//

import UIKit

class CookbookView: UIView {
    
    var labelCookbookTitle: UILabel!
    var imageViewBook: UIImageView!
    var textFieldRecipeTitle: UITextField!
    var textViewRecipeDetails: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        
        setupBookImageView()
        setupCookbookTitleLabel()
        setupRecipeTitleTextField()
        setupRecipeDetailsTextView()
        
        initConstraints()
    }
    
    func setupBookImageView() {
        imageViewBook = UIImageView()
        imageViewBook.contentMode = .scaleAspectFill // Fill the screen
        imageViewBook.clipsToBounds = true
        imageViewBook.image = UIImage(named: "cookbookview")
        imageViewBook.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageViewBook)
    }
    
    func setupCookbookTitleLabel() {
        labelCookbookTitle = UILabel()
        labelCookbookTitle.text = "" // Will be set from controller
        labelCookbookTitle.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        labelCookbookTitle.textAlignment = .center
        labelCookbookTitle.textColor = .label
        labelCookbookTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelCookbookTitle)
    }
    
    func setupRecipeTitleTextField() {
        textFieldRecipeTitle = UITextField()
        textFieldRecipeTitle.placeholder = "Recipe Title"
        textFieldRecipeTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        textFieldRecipeTitle.textAlignment = .left
        textFieldRecipeTitle.backgroundColor = .clear
        textFieldRecipeTitle.borderStyle = .none
        textFieldRecipeTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldRecipeTitle)
    }
    
    func setupRecipeDetailsTextView() {
        textViewRecipeDetails = UITextView()
        textViewRecipeDetails.text = "Recipe Details"
        textViewRecipeDetails.font = UIFont.systemFont(ofSize: 16)
        textViewRecipeDetails.textAlignment = .left
        textViewRecipeDetails.backgroundColor = .clear
        textViewRecipeDetails.textColor = .label
        textViewRecipeDetails.isEditable = true
        textViewRecipeDetails.isScrollEnabled = true
        textViewRecipeDetails.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textViewRecipeDetails)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Book Background Image - Fill entire screen edge to edge
            imageViewBook.topAnchor.constraint(equalTo: self.topAnchor),
            imageViewBook.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageViewBook.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageViewBook.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            // Cookbook Title - Above the book pages
            labelCookbookTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 120),
            labelCookbookTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            labelCookbookTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            
            // Recipe Title TextField - On the left page
            textFieldRecipeTitle.topAnchor.constraint(equalTo: labelCookbookTitle.bottomAnchor, constant: 100),
            textFieldRecipeTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            textFieldRecipeTitle.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -30),
            textFieldRecipeTitle.heightAnchor.constraint(equalToConstant: 44),
            
            // Recipe Details TextView - Below title on left page
            textViewRecipeDetails.topAnchor.constraint(equalTo: textFieldRecipeTitle.bottomAnchor, constant: 16),
            textViewRecipeDetails.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            textViewRecipeDetails.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -30),
            textViewRecipeDetails.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -150)
        ])
    }
    
    func updateCookbookTitle(_ title: String) {
        labelCookbookTitle.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
