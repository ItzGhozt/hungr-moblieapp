//
//  FridgeViewController.swift
//  hungr
//
//  Fridge screen controller
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FridgeViewController: UIViewController {
    
    let fridgeView = FridgeView()
    
    let database = Firestore.firestore()
    
    var currentUser: FirebaseAuth.User?
    
    override func loadView() {
        view = fridgeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Fridge"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        currentUser = Auth.auth().currentUser
    }
}
