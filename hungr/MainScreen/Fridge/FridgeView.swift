//
//  FridgeView.swift
//  hungr
//
//  Fridge screen UI
//

import UIKit

class FridgeView: UIView {
    
    var labelTitle: UILabel!
    var tableViewItems: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1.0)
        
        setupTitleLabel()
        setupTableViewItems()
        initConstraints()
    }
    
    func setupTitleLabel() {
        labelTitle = UILabel()
        labelTitle.text = "Your Fridge Items"
        labelTitle.font = UIFont.boldSystemFont(ofSize: 24)
        labelTitle.textAlignment = .center
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelTitle)
    }
    
    func setupTableViewItems() {
        tableViewItems = UITableView()
        tableViewItems.register(FridgeItemTableViewCell.self, forCellReuseIdentifier: "fridgeItem")
        tableViewItems.separatorStyle = .singleLine
        tableViewItems.backgroundColor = .clear
        tableViewItems.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewItems)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            labelTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            labelTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            
            tableViewItems.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 16),
            tableViewItems.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableViewItems.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableViewItems.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
