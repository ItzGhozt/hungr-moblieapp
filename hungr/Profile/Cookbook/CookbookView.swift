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
    var tableViewRecipes: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        
        setupBookImageView()
        setupCookbookTitleLabel()
        setupTableViewRecipes()
        
        initConstraints()
    }
    
    func setupBookImageView() {
        imageViewBook = UIImageView()
        imageViewBook.contentMode = .scaleAspectFill
        imageViewBook.clipsToBounds = true
        imageViewBook.image = UIImage(named: "cookbookview")
        imageViewBook.alpha = 0.3 // Make it more subtle so table view is readable
        imageViewBook.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageViewBook)
    }
    
    func setupCookbookTitleLabel() {
        labelCookbookTitle = UILabel()
        labelCookbookTitle.text = ""
        labelCookbookTitle.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        labelCookbookTitle.textAlignment = .center
        labelCookbookTitle.textColor = .label
        labelCookbookTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelCookbookTitle)
    }
    
    func setupTableViewRecipes() {
        tableViewRecipes = UITableView()
        tableViewRecipes.register(RecipeTableViewCell.self, forCellReuseIdentifier: "recipe")
        tableViewRecipes.separatorStyle = .singleLine
        tableViewRecipes.backgroundColor = .clear
        tableViewRecipes.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewRecipes)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Book Background Image - Fill entire screen edge to edge
            imageViewBook.topAnchor.constraint(equalTo: self.topAnchor),
            imageViewBook.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageViewBook.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageViewBook.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            // Cookbook Title
            labelCookbookTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            labelCookbookTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            labelCookbookTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            // Table View for recipes
            tableViewRecipes.topAnchor.constraint(equalTo: labelCookbookTitle.bottomAnchor, constant: 16),
            tableViewRecipes.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableViewRecipes.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableViewRecipes.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
    func updateCookbookTitle(_ title: String) {
        labelCookbookTitle.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
