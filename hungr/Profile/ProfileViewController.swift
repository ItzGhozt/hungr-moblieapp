//
//  ProfileViewController.swift
//  hungr
//
//  Profile screen controller
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    let profileView = ProfileView()
    
    let database = Firestore.firestore()
    
    var currentUser: FirebaseAuth.User?
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Add Logout button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(onLogoutTapped)
        )
        
        // Add Cookbook button target
        profileView.buttonCookbook.addTarget(self, action: #selector(onCookbookTapped), for: .touchUpInside)
        
        currentUser = Auth.auth().currentUser
        
        loadUserProfile()
    }
    
    func loadUserProfile() {
        guard let user = currentUser else { return }
        
        // Load user data from Firestore
        database.collection("users").document(user.uid).getDocument { [weak self] document, error in
            if let error = error {
                print("Error loading profile: \(error)")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                let name = data?["name"] as? String ?? user.displayName ?? "User"
                let email = data?["email"] as? String ?? user.email ?? ""
                
                DispatchQueue.main.async {
                    self?.profileView.updateProfile(name: name, email: email)
                }
            } else {
                // Use Auth data as fallback
                DispatchQueue.main.async {
                    self?.profileView.updateProfile(
                        name: user.displayName ?? "User",
                        email: user.email ?? ""
                    )
                }
            }
        }
    }
    
    @objc func onCookbookTapped() {
        let cookbookVC = CookbookViewController()
        navigationController?.pushViewController(cookbookVC, animated: true)
    }
    
    @objc func onLogoutTapped() {
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { _ in
            self.logoutUser()
        })
        
        present(alert, animated: true)
    }
    
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            // Navigate back to home page
            navigationController?.popToRootViewController(animated: true)
        } catch {
            showAlert(title: "Error", message: "Failed to logout: \(error.localizedDescription)")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
