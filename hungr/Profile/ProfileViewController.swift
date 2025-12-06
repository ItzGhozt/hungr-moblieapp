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
    
    var isEditMode = false
    
    override func loadView() {
        view = profileView
        HelpButtonHelper.addHelpButton(to: self, message: HelpButtonHelper.profileHelp)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                title: "Logout",
                style: .plain,
                target: self,
                action: #selector(onLogoutTapped)
            ),
            UIBarButtonItem(
                title: "Edit",
                style: .plain,
                target: self,
                action: #selector(onEditTapped)
            )
        ]
        
        profileView.buttonAddCookbook.addTarget(self, action: #selector(onAddCookbookTapped), for: .touchUpInside)
        
        currentUser = Auth.auth().currentUser
        
        setupProfileImageTap()
        
        loadUserProfile()
        loadCookbooks()
        loadProfileImage()
    }
    
    @objc func onEditTapped() {
        isEditMode.toggle()
        
        if isEditMode {
            navigationItem.rightBarButtonItems?[1].title = "Done"
            showDeleteButtons()
        } else {
            navigationItem.rightBarButtonItems?[1].title = "Edit"
            hideDeleteButtons()
        }
    }
    
    func showDeleteButtons() {
        for (index, button) in cookbookButtons.enumerated() {
            let deleteButton = UIButton(type: .custom)
            deleteButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
            deleteButton.tintColor = .systemRed
            deleteButton.backgroundColor = .systemBackground
            deleteButton.layer.cornerRadius = 12
            deleteButton.tag = index + 1000
            deleteButton.translatesAutoresizingMaskIntoConstraints = false
            deleteButton.addTarget(self, action: #selector(onDeleteCookbookTapped(_:)), for: .touchUpInside)
            
            profileView.addSubview(deleteButton)
            
            NSLayoutConstraint.activate([
                deleteButton.topAnchor.constraint(equalTo: button.topAnchor, constant: -8),
                deleteButton.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 8),
                deleteButton.widthAnchor.constraint(equalToConstant: 24),
                deleteButton.heightAnchor.constraint(equalToConstant: 24)
            ])
        }
    }
    
    func hideDeleteButtons() {
        for subview in profileView.subviews {
            if let button = subview as? UIButton, button.tag >= 1000 {
                button.removeFromSuperview()
            }
        }
    }
    
    @objc func onDeleteCookbookTapped(_ sender: UIButton) {
        let index = sender.tag - 1000
        guard index < cookbooks.count else { return }
        
        let cookbook = cookbooks[index]
        confirmDeleteCookbook(cookbookId: cookbook.id, name: cookbook.name)
    }

    @objc func onAddCookbookTapped() {
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
            
            self?.cookbooks.append((id: cookbookId, name: name, color: randomColor))
            if let index = self?.cookbooks.count {
                self?.addCookbookToView(name: name, color: randomColor, at: index - 1)
            }
        }
    }
    
    func loadCookbooks() {
        guard let userId = currentUser?.uid else {
            return
        }
        
        database.collection("cookbooks")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error loading cookbooks: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    return
                }
                
                self?.cookbooks.removeAll()
                self?.cookbookButtons.forEach { $0.removeFromSuperview() }
                self?.cookbookLabels.forEach { $0.removeFromSuperview() }
                self?.cookbookButtons.removeAll()
                self?.cookbookLabels.removeAll()
                
                for (index, document) in documents.enumerated() {
                    let data = document.data()
                    let id = document.documentID
                    let name = data["name"] as? String ?? "Untitled"
                    let color = data["color"] as? String ?? "cookbook_green"
                    
                    self?.cookbooks.append((id: id, name: name, color: color))
                    self?.addCookbookToView(name: name, color: color, at: index)
                }
            }
    }
    
    func addCookbookToView(name: String, color: String, at index: Int) {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = index
        button.addTarget(self, action: #selector(onCookbookTapped(_:)), for: .touchUpInside)
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        
        if let image = UIImage(named: color) {
            imageView.image = image.withRenderingMode(.alwaysOriginal)
        } else {
            imageView.image = UIImage(systemName: "book.fill")
            imageView.tintColor = .systemBlue
        }
        
        button.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: button.topAnchor, constant: 5),
            imageView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 5),
            imageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -5),
            imageView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -5)
        ])
        
        profileView.addSubview(button)
        cookbookButtons.append(button)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = name
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .label
        
        profileView.addSubview(label)
        cookbookLabels.append(label)
        
        let row = index / 3
        let column = index % 3
        let spacing: CGFloat = 16
        let buttonSize: CGFloat = 100
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: profileView.labelMyCookbooks.bottomAnchor, constant: 16 + CGFloat(row) * (buttonSize + 32 + spacing)),
            button.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 24 + CGFloat(column) * (buttonSize + spacing)),
            button.widthAnchor.constraint(equalToConstant: buttonSize),
            button.heightAnchor.constraint(equalToConstant: buttonSize),
            
            label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 4),
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor)
        ])
        
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
        if isEditMode {
            return
        }
        
        let index = sender.tag
        let cookbook = cookbooks[index]
        
        let cookbookVC = CookbookViewController()
        cookbookVC.cookbookId = cookbook.id
        cookbookVC.cookbookName = cookbook.name
        navigationController?.pushViewController(cookbookVC, animated: true)
    }
    
    func confirmDeleteCookbook(cookbookId: String, name: String) {
        let alert = UIAlertController(
            title: "Delete \(name)?",
            message: "This will also delete all recipes in this cookbook. This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteCookbook(cookbookId: cookbookId)
        })
        
        present(alert, animated: true)
    }
    
    func deleteCookbook(cookbookId: String) {
        database.collection("recipes")
            .whereField("cookbookId", isEqualTo: cookbookId)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    self?.showAlert(title: "Error", message: "Failed to delete recipes: \(error.localizedDescription)")
                    return
                }
                
                let batch = self?.database.batch()
                snapshot?.documents.forEach { document in
                    batch?.deleteDocument(document.reference)
                }
                
                batch?.commit { error in
                    if let error = error {
                        self?.showAlert(title: "Error", message: "Failed to delete recipes: \(error.localizedDescription)")
                        return
                    }
                    
                    self?.database.collection("cookbooks").document(cookbookId).delete { error in
                        if let error = error {
                            self?.showAlert(title: "Error", message: "Failed to delete cookbook: \(error.localizedDescription)")
                            return
                        }
                        
                        self?.isEditMode = false
                        self?.navigationItem.rightBarButtonItems?[1].title = "Edit"
                        self?.loadCookbooks()
                    }
                }
            }
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setupProfileImageTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onProfileImageTapped))
        profileView.imageViewProfile.isUserInteractionEnabled = true
        profileView.imageViewProfile.addGestureRecognizer(tap)
    }
    
    @objc func onProfileImageTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            profileView.imageViewProfile.image = image
            profileView.imageViewProfile.contentMode = .scaleAspectFill
            saveProfileImage(image)
        }
    }
    
    func saveProfileImage(_ image: UIImage) {
        guard let userId = currentUser?.uid,
              let imageData = image.jpegData(compressionQuality: 0.7) else { return }
        
        let base64String = imageData.base64EncodedString()
        
        database.collection("users").document(userId).setData([
            "profileImage": base64String
        ], merge: true)
    }
    
    func loadProfileImage() {
        guard let userId = currentUser?.uid else { return }
        
        database.collection("users").document(userId).getDocument { [weak self] document, error in
            if let data = document?.data(),
               let base64String = data["profileImage"] as? String,
               let imageData = Data(base64Encoded: base64String),
               let image = UIImage(data: imageData) {
                
                DispatchQueue.main.async {
                    self?.profileView.imageViewProfile.image = image
                    self?.profileView.imageViewProfile.contentMode = .scaleAspectFill
                }
            }
        }
    }
}
