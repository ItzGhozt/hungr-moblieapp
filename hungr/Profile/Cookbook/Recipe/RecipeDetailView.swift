//
//  RecipeDetailView.swift
//  hungr
//
//  Created by Isabel Yeow on 12/5/25.
//


//
//  RecipeDetailView.swift
//  hungr
//
//  Recipe detail view UI
//

import UIKit

class RecipeDetailView: UIView {
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var labelTitle: UILabel!
    var textFieldTitle: UITextField!
    
    var labelDescription: UILabel!
    var textViewDescription: UITextView!
    
    var labelTimes: UILabel!
    var stackViewTimes: UIStackView!
    var textFieldPrepTime: UITextField!
    var textFieldCookTime: UITextField!
    var textFieldServings: UITextField!
    
    var labelIngredients: UILabel!
    var textViewIngredients: UITextView!
    
    var labelInstructions: UILabel!
    var textViewInstructions: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        
        setupScrollView()
        setupContentView()
        setupTitleSection()
        setupDescriptionSection()
        setupTimesSection()
        setupIngredientsSection()
        setupInstructionsSection()
        
        initConstraints()
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
    }
    
    func setupContentView() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }
    
    func setupTitleSection() {
        labelTitle = UILabel()
        labelTitle.text = "Recipe Title"
        labelTitle.font = .systemFont(ofSize: 14, weight: .semibold)
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelTitle)
        
        textFieldTitle = UITextField()
        textFieldTitle.placeholder = "Enter recipe title"
        textFieldTitle.borderStyle = .roundedRect
        textFieldTitle.font = .systemFont(ofSize: 16)
        textFieldTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textFieldTitle)
    }
    
    func setupDescriptionSection() {
        labelDescription = UILabel()
        labelDescription.text = "Description"
        labelDescription.font = .systemFont(ofSize: 14, weight: .semibold)
        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelDescription)
        
        textViewDescription = UITextView()
        textViewDescription.font = .systemFont(ofSize: 16)
        textViewDescription.layer.borderColor = UIColor.systemGray4.cgColor
        textViewDescription.layer.borderWidth = 1.0
        textViewDescription.layer.cornerRadius = 8
        textViewDescription.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        textViewDescription.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textViewDescription)
    }
    
    func setupTimesSection() {
        labelTimes = UILabel()
        labelTimes.text = "Times & Servings"
        labelTimes.font = .systemFont(ofSize: 14, weight: .semibold)
        labelTimes.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelTimes)
        
        textFieldPrepTime = createTimeTextField(placeholder: "Prep (min)")
        textFieldCookTime = createTimeTextField(placeholder: "Cook (min)")
        textFieldServings = createTimeTextField(placeholder: "Servings")
        
        stackViewTimes = UIStackView(arrangedSubviews: [textFieldPrepTime, textFieldCookTime, textFieldServings])
        stackViewTimes.axis = .horizontal
        stackViewTimes.distribution = .fillEqually
        stackViewTimes.spacing = 12
        stackViewTimes.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackViewTimes)
    }
    
    func createTimeTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.font = .systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    func setupIngredientsSection() {
        labelIngredients = UILabel()
        labelIngredients.text = "Ingredients"
        labelIngredients.font = .systemFont(ofSize: 14, weight: .semibold)
        labelIngredients.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelIngredients)
        
        textViewIngredients = UITextView()
        textViewIngredients.text = "Enter ingredients (one per line)"
        textViewIngredients.textColor = .lightGray
        textViewIngredients.font = .systemFont(ofSize: 16)
        textViewIngredients.layer.borderColor = UIColor.systemGray4.cgColor
        textViewIngredients.layer.borderWidth = 1.0
        textViewIngredients.layer.cornerRadius = 8
        textViewIngredients.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        textViewIngredients.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textViewIngredients)
    }
    
    func setupInstructionsSection() {
        labelInstructions = UILabel()
        labelInstructions.text = "Instructions"
        labelInstructions.font = .systemFont(ofSize: 14, weight: .semibold)
        labelInstructions.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelInstructions)
        
        textViewInstructions = UITextView()
        textViewInstructions.text = "Enter instructions (one per line)"
        textViewInstructions.textColor = .lightGray
        textViewInstructions.font = .systemFont(ofSize: 16)
        textViewInstructions.layer.borderColor = UIColor.systemGray4.cgColor
        textViewInstructions.layer.borderWidth = 1.0
        textViewInstructions.layer.cornerRadius = 8
        textViewInstructions.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        textViewInstructions.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textViewInstructions)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title section
            labelTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            labelTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            textFieldTitle.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 8),
            textFieldTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textFieldTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textFieldTitle.heightAnchor.constraint(equalToConstant: 44),
            
            // Description section
            labelDescription.topAnchor.constraint(equalTo: textFieldTitle.bottomAnchor, constant: 20),
            labelDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            textViewDescription.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: 8),
            textViewDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textViewDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textViewDescription.heightAnchor.constraint(equalToConstant: 80),
            
            // Times section
            labelTimes.topAnchor.constraint(equalTo: textViewDescription.bottomAnchor, constant: 20),
            labelTimes.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelTimes.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            stackViewTimes.topAnchor.constraint(equalTo: labelTimes.bottomAnchor, constant: 8),
            stackViewTimes.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackViewTimes.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackViewTimes.heightAnchor.constraint(equalToConstant: 44),
            
            // Ingredients section
            labelIngredients.topAnchor.constraint(equalTo: stackViewTimes.bottomAnchor, constant: 20),
            labelIngredients.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelIngredients.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            textViewIngredients.topAnchor.constraint(equalTo: labelIngredients.bottomAnchor, constant: 8),
            textViewIngredients.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textViewIngredients.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textViewIngredients.heightAnchor.constraint(equalToConstant: 150),
            
            // Instructions section
            labelInstructions.topAnchor.constraint(equalTo: textViewIngredients.bottomAnchor, constant: 20),
            labelInstructions.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelInstructions.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            textViewInstructions.topAnchor.constraint(equalTo: labelInstructions.bottomAnchor, constant: 8),
            textViewInstructions.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textViewInstructions.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textViewInstructions.heightAnchor.constraint(equalToConstant: 200),
            textViewInstructions.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}