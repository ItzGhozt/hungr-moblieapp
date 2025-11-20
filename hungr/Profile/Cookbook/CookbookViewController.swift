//
//  CookbookViewController.swift
//  hungr
//
//  Created by Isabel Yeow on 11/19/25.
//

//
//  CookbookViewController.swift
//  hungr
//
//  Cookbook screen controller
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CookbookViewController: UIViewController {
    
    let cookbookView = CookbookView()
    
    let database = Firestore.firestore()
    
    var currentUser: FirebaseAuth.User?
    
    override func loadView() {
        view = cookbookView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cookbook"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        currentUser = Auth.auth().currentUser
    }
}
