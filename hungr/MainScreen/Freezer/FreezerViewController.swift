//
//  FreezerViewController.swift
//  hungr
//
//  Freezer screen controller
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FreezerViewController: UIViewController {
    
    let freezerView = FreezerView()
    
    let database = Firestore.firestore()
    
    var currentUser: FirebaseAuth.User?
    
    override func loadView() {
        view = freezerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Freezer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        currentUser = Auth.auth().currentUser
    }
}
