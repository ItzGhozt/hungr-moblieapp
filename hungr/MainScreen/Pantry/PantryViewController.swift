//
//  PantryViewController.swift
//  hungr
//
//  Pantry screen controller
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PantryViewController: UIViewController {
    
    let pantryView = PantryView()
    
    let database = Firestore.firestore()
    
    var currentUser: FirebaseAuth.User?
    
    override func loadView() {
        view = pantryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pantry"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        currentUser = Auth.auth().currentUser
    }
}
