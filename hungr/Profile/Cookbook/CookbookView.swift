//
//  CookBookView.swift
//  hungr
//
//  Created by Isabel Yeow on 11/19/25.
//

//
//  CookbookView.swift
//  hungr
//
//  Cookbook screen UI
//

import UIKit

class CookbookView: UIView {
    
    var labelTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        
        setupTitleLabel()
        initConstraints()
    }
    
    func setupTitleLabel() {
        labelTitle = UILabel()
        labelTitle.text = "Your Cookbook"
        labelTitle.font = UIFont.boldSystemFont(ofSize: 24)
        labelTitle.textAlignment = .center
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelTitle)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            labelTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            labelTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            labelTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            labelTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
