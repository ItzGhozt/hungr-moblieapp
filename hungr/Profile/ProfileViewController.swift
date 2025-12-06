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
    
    var cookbooks: [(id: String, name: String, color: String)] = []
    var cookbookButtons: [UIButton] = []
    var cookbookLabels: [UILabel] = []
    
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
        
        // Add button target for Add Cookbook button only
        profileView.buttonAddCookbook.addTarget(self, action: #selector(onAddCookbookTapped), for: .touchUpInside)
        
        currentUser = Auth.auth().currentUser
        
        loadUserProfile()
        loadCookbooks()
    }

    @objc func onAddCookbookTapped() {
        // Show alert to enter cookbook name
        let alert = UIAlertController(
            title: "New Cookbook",
            message: "Enter a name for your cookbook",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Cookbook Name"
            textField.autocapitalizationType = .words
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Create", style: .default) { [weak self] _ in
            guard let name = alert.textFields?.first?.text, !name.isEmpty else {
                self?.showAlert(title: "Error", message: "Please enter a cookbook name")
                return
            }
            
            self?.createCookbook(name: name)
        })
        
        present(alert, animated: true)
    }
    
    func createCookbook(name: String) {
        guard let userId = currentUser?.uid else {
            showAlert(title: "Error", message: "User not authenticated")
            return
        }
        
        let cookbookColors = ["cookbook_green", "cookbook_yellow", "cookbook_pink"]
        let randomColor = cookbookColors.randomElement() ?? "cookbook_green"
        
        // Create a new document reference to get the ID
        let docRef = database.collection("cookbooks").document()
        let cookbookId = docRef.documentID
        
        let cookbookData: [String: Any] = [
            "name": name,
            "color": randomColor,
            "userId": userId,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        docRef.setData(cookbookData) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: "Failed to create cookbook: \(error.localizedDescription)")
                return
            }
            
            // Add to local array and UI
            self?.cookbooks.append((id: cookbookId, name: name, color: randomColor))
            if let index = self?.cookbooks.count {
                self?.addCookbookToView(name: name, color: randomColor, at: index - 1)
            }
        }
    }
    
    func loadCookbooks() {
        guard let userId = currentUser?.uid else {
            print("❌ No user ID found")
            return
        }
        
        print("🔍 Loading cookbooks for user: \(userId)")
        
        database.collection("cookbooks")
            .whereField("userId", isEqualTo: userId)
//            .order(by: "createdAt")
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("❌ Error loading cookbooks: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("❌ No documents found")
                    return
                }
                
                print("✅ Found \(documents.count) cookbooks")
                
                // Clear existing cookbooks
                self?.cookbooks.removeAll()
                self?.cookbookButtons.forEach { $0.removeFromSuperview() }
                self?.cookbookLabels.forEach { $0.removeFromSuperview() }
                self?.cookbookButtons.removeAll()
                self?.cookbookLabels.removeAll()
                
                // Add each cookbook
                for (index, document) in documents.enumerated() {
                    let data = document.data()
                    let id = document.documentID
                    let name = data["name"] as? String ?? "Untitled"
                    let color = data["color"] as? String ?? "cookbook_green"
                    
                    print("📚 Loading cookbook: \(name)")
                    
                    self?.cookbooks.append((id: id, name: name, color: color))
                    self?.addCookbookToView(name: name, color: color, at: index)
                }
            }
    }
    
    func addCookbookToView(name: String, color: String, at index: Int) {
        // Create container button
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = index
        button.addTarget(self, action: #selector(onCookbookTapped(_:)), for: .touchUpInside)
        
        // Create image view to hold the cookbook icon
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        
        // Try to load the image
        if let image = UIImage(named: color) {
            // Force the image to render as original (no tint)
            imageView.image = image.withRenderingMode(.alwaysOriginal)
        } else {
            imageView.image = UIImage(systemName: "book.fill")
            imageView.tintColor = .systemBlue
        }
        
        button.addSubview(imageView)
        
        // Constrain imageView to fill the button with padding
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: button.topAnchor, constant: 5),
            imageView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 5),
            imageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -5),
            imageView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -5)
        ])
        
        profileView.addSubview(button)
        cookbookButtons.append(button)
        
        // Create label for cookbook name
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = name
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .label
        
        profileView.addSubview(label)
        cookbookLabels.append(label)
        
        // Calculate position (3 cookbooks per row)
        let row = index / 3
        let column = index % 3
        let spacing: CGFloat = 16
        let buttonSize: CGFloat = 100
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: profileView.labelMyCookbooks.bottomAnchor, constant: 16 + CGFloat(row) * (buttonSize + 32 + spacing)),
            button.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 24 + CGFloat(column) * (buttonSize + spacing)),
            button.widthAnchor.constraint(equalToConstant: buttonSize),
            button.heightAnchor.constraint(equalToConstant: buttonSize),
            
            // Position label below button
            label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 4),
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor)
        ])
        
        // Update add button position
        updateAddButtonPosition()
    }
    
    func updateAddButtonPosition() {
        profileView.buttonAddCookbook.removeFromSuperview()
        profileView.addSubview(profileView.buttonAddCookbook)
        
        let totalCookbooks = cookbooks.count
        let row = totalCookbooks / 3
        let column = totalCookbooks % 3
        let spacing: CGFloat = 16
        let buttonSize: CGFloat = 100
        let labelHeight: CGFloat = 32
        
        NSLayoutConstraint.activate([
            profileView.buttonAddCookbook.topAnchor.constraint(equalTo: profileView.labelMyCookbooks.bottomAnchor, constant: 16 + CGFloat(row) * (buttonSize + labelHeight + spacing)),
            profileView.buttonAddCookbook.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 24 + CGFloat(column) * (buttonSize + spacing)),
            profileView.buttonAddCookbook.widthAnchor.constraint(equalToConstant: buttonSize),
            profileView.buttonAddCookbook.heightAnchor.constraint(equalToConstant: buttonSize)
        ])
    }
    
    @objc func onCookbookTapped(_ sender: UIButton) {
        let index = sender.tag
        let cookbook = cookbooks[index]
        
        let cookbookVC = CookbookViewController()
        cookbookVC.cookbookId = cookbook.id
        cookbookVC.cookbookName = cookbook.name
        navigationController?.pushViewController(cookbookVC, animated: true)
    }
    
    func loadUserProfile() {
        guard let user = currentUser else { return }
        
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
                DispatchQueue.main.async {
                    self?.profileView.updateProfile(
                        name: user.displayName ?? "User",
                        email: user.email ?? ""
                    )
                }
            }
        }
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
