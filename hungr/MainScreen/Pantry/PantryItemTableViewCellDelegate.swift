//
//  PantryItemTableViewCellDelegate.swift
//  hungr
//
//  Created by Isabel Yeow on 12/6/25.
//


//
//  PantryItemTableViewCell.swift
//  hungr
//
//  Pantry item table view cell
//

import UIKit

protocol PantryItemTableViewCellDelegate: AnyObject {
    func deleteButtonTapped(for itemId: String)
}

class PantryItemTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var labelItemName: UILabel!
    var labelQuantity: UILabel!
    var labelExpiryDate: UILabel!
    var buttonDelete: UIButton!
    
    weak var delegate: PantryItemTableViewCellDelegate?
    var itemId: String = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        setupWrapperCellView()
        setupLabelItemName()
        setupLabelQuantity()
        setupLabelExpiryDate()
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
    
    func setupLabelItemName(){
        labelItemName = UILabel()
        labelItemName.font = .systemFont(ofSize: 16, weight: .semibold)
        labelItemName.numberOfLines = 1
        labelItemName.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelItemName)
    }
    
    func setupLabelQuantity(){
        labelQuantity = UILabel()
        labelQuantity.font = .systemFont(ofSize: 14)
        labelQuantity.textColor = .secondaryLabel
        labelQuantity.numberOfLines = 1
        labelQuantity.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelQuantity)
    }
    
    func setupLabelExpiryDate(){
        labelExpiryDate = UILabel()
        labelExpiryDate.font = .systemFont(ofSize: 12)
        labelExpiryDate.textColor = .systemOrange
        labelExpiryDate.numberOfLines = 1
        labelExpiryDate.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelExpiryDate)
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
        delegate?.deleteButtonTapped(for: itemId)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            labelItemName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 10),
            labelItemName.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 12),
            labelItemName.trailingAnchor.constraint(equalTo: buttonDelete.leadingAnchor, constant: -8),
            
            labelQuantity.topAnchor.constraint(equalTo: labelItemName.bottomAnchor, constant: 4),
            labelQuantity.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 12),
            labelQuantity.trailingAnchor.constraint(equalTo: buttonDelete.leadingAnchor, constant: -8),
            
            labelExpiryDate.topAnchor.constraint(equalTo: labelQuantity.bottomAnchor, constant: 2),
            labelExpiryDate.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 12),
            labelExpiryDate.trailingAnchor.constraint(equalTo: buttonDelete.leadingAnchor, constant: -8),
            labelExpiryDate.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -10),
            
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