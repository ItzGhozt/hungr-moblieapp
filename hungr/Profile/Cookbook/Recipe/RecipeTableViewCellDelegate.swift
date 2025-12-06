//
//  RecipeTableViewCellDelegate.swift
//  hungr
//
//  Created by Isabel Yeow on 12/5/25.
//


//
//  RecipeTableViewCell.swift
//  hungr
//
//  Recipe table view cell
//

import UIKit

protocol RecipeTableViewCellDelegate: AnyObject {
    func deleteButtonTapped(for recipeId: String)
}

class RecipeTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var labelRecipeTitle: UILabel!
    var labelRecipeDescription: UILabel!
    var buttonDelete: UIButton!
    
    weak var delegate: RecipeTableViewCellDelegate?
    var recipeId: String = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        setupWrapperCellView()
        setupLabelRecipeTitle()
        setupLabelRecipeDescription()
        setupButtonDelete()
        
        initConstraints()
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UIView()
        wrapperCellView.backgroundColor = .systemBackground
        wrapperCellView.layer.cornerRadius = 8.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 2.0
        wrapperCellView.layer.shadowOpacity = 0.5
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelRecipeTitle(){
        labelRecipeTitle = UILabel()
        labelRecipeTitle.font = .systemFont(ofSize: 16, weight: .semibold)
        labelRecipeTitle.numberOfLines = 1
        labelRecipeTitle.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelRecipeTitle)
    }
    
    func setupLabelRecipeDescription(){
        labelRecipeDescription = UILabel()
        labelRecipeDescription.font = .systemFont(ofSize: 14)
        labelRecipeDescription.textColor = .secondaryLabel
        labelRecipeDescription.numberOfLines = 2
        labelRecipeDescription.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelRecipeDescription)
    }
    
    func setupButtonDelete(){
        buttonDelete = UIButton(type: .system)
        buttonDelete.setImage(UIImage(systemName: "trash"), for: .normal)
        buttonDelete.tintColor = .systemRed
        buttonDelete.isUserInteractionEnabled = true
        buttonDelete.isEnabled = true
        buttonDelete.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        buttonDelete.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        buttonDelete.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonDelete)
    }
    
    @objc func deleteButtonTapped() {
        delegate?.deleteButtonTapped(for: recipeId)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            labelRecipeTitle.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 10),
            labelRecipeTitle.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 12),
            labelRecipeTitle.trailingAnchor.constraint(equalTo: buttonDelete.leadingAnchor, constant: -8),
            
            labelRecipeDescription.topAnchor.constraint(equalTo: labelRecipeTitle.bottomAnchor, constant: 4),
            labelRecipeDescription.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 12),
            labelRecipeDescription.trailingAnchor.constraint(equalTo: buttonDelete.leadingAnchor, constant: -8),
            labelRecipeDescription.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -10),
            
            buttonDelete.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            buttonDelete.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -10),
            buttonDelete.widthAnchor.constraint(equalToConstant: 44),
            buttonDelete.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bringSubviewToFront(buttonDelete)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}