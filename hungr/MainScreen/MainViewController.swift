//
//  MainViewController.swift
//  hungr
//
//  Home page controller
//

import UIKit
import FirebaseAuth
import AVFoundation

class MainViewController: UIViewController {
    
    let mainView = MainView()
    
    var currentUser: FirebaseAuth.User?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove title
        title = ""
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Hide navigation bar completely on home screen
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        navigationItem.hidesBackButton = true
        
        // Add button targets
        mainView.buttonGetStarted.addTarget(self, action: #selector(onGetStartedTapped), for: .touchUpInside)
        mainView.buttonCamera.addTarget(self, action: #selector(onCameraTapped), for: .touchUpInside)
        mainView.buttonProfile.addTarget(self, action: #selector(onProfileTapped), for: .touchUpInside)
        mainView.buttonFridge.addTarget(self, action: #selector(onFridgeTapped), for: .touchUpInside)
        mainView.buttonPantry.addTarget(self, action: #selector(onPantryTapped), for: .touchUpInside)
        mainView.buttonFreezer.addTarget(self, action: #selector(onFreezerTapped), for: .touchUpInside)
        
        currentUser = Auth.auth().currentUser
        
        // Update UI based on login state
        updateUIForLoginState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide navigation bar when returning to home
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        currentUser = Auth.auth().currentUser
        updateUIForLoginState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show navigation bar when leaving home
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func updateUIForLoginState() {
        if currentUser != nil {
            // User is logged in
            mainView.buttonGetStarted.isHidden = true
            mainView.buttonCamera.isHidden = false
            mainView.buttonProfile.isHidden = false
            mainView.buttonFridge.isHidden = false
            mainView.buttonPantry.isHidden = false
            mainView.buttonFreezer.isHidden = false
        } else {
            // User is not logged in
            mainView.buttonGetStarted.isHidden = false
            mainView.buttonCamera.isHidden = true
            mainView.buttonProfile.isHidden = true
            mainView.buttonFridge.isHidden = true
            mainView.buttonPantry.isHidden = true
            mainView.buttonFreezer.isHidden = true
        }
    }
    
    @objc func onGetStartedTapped() {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @objc func onCameraTapped() {
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthStatus {
        case .authorized:
            openCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.openCamera()
                    } else {
                        self.showAlert(title: "Camera Permission Required", message: "Please enable camera access in Settings")
                    }
                }
            }
        case .denied, .restricted:
            showAlert(title: "Camera Permission Required", message: "Please enable camera access in Settings to use this feature")
        @unknown default:
            break
        }
    }
    
    @objc func onProfileTapped() {
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc func onFridgeTapped() {
        let fridgeVC = FridgeViewController()
        navigationController?.pushViewController(fridgeVC, animated: true)
    }
    
    @objc func onPantryTapped() {
        let pantryVC = PantryViewController()
        navigationController?.pushViewController(pantryVC, animated: true)
    }
    
    @objc func onFreezerTapped() {
        let freezerVC = FreezerViewController()
        navigationController?.pushViewController(freezerVC, animated: true)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        } else {
            showAlert(title: "Camera Not Available", message: "Camera is not available on this device")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Camera Delegate
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            print("Image captured successfully!")
            showAlert(title: "Success", message: "Photo captured!")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
