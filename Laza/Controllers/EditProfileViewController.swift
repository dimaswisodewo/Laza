//
//  EditProfileViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 22/08/23.
//

import UIKit
import PhotosUI

protocol EditProfileViewControllerDelegate: AnyObject {
    
    func onProfileUpdated(updatedProfile: Profile)
}

class EditProfileViewController: UIViewController {

    static let identifier = "EditProfileViewController"
    
    weak var delegate: EditProfileViewControllerDelegate?
    
    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var changeProfilePicButton: CircleButton! {
        didSet {
            changeProfilePicButton.addTarget(self, action: #selector(changeProfileButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
            profileImageView.backgroundColor = .lightGray
            profileImageView.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet weak var fullNameLabel: CustomTextField! {
        didSet {
            fullNameLabel.setTitle(title: "Full Name")
            fullNameLabel.autocorrectionType = .no
            fullNameLabel.autocapitalizationType = .words
        }
    }
    
    @IBOutlet weak var usernameLabel: CustomTextField! {
        didSet {
            usernameLabel.setTitle(title: "Username")
            usernameLabel.autocorrectionType = .no
        }
    }
    
    @IBOutlet weak var emailLabel: CustomTextField! {
        didSet {
            emailLabel.setTitle(title: "Email")
            emailLabel.autocorrectionType = .no
        }
    }
    
    @IBOutlet weak var ctaButton: UIButton! {
        didSet {
            ctaButton.addTarget(self, action: #selector(ctaButtonPressed), for: .touchUpInside)
        }
    }
    
    private var model: Profile?
    
    private let viewModel = EditProfileViewModel()
    
    private var phPicker: PHPickerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.isHidden = true
        
        applyModel()
        
        setupPHPicker()
    }
    
    func configure(model: Profile) {
        self.model = model
    }
    
    private func setupPHPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images

        phPicker = PHPickerViewController(configuration: config)
        phPicker.delegate = self
    }
    
    private func applyModel() {
        fullNameLabel.text = model?.fullName
        usernameLabel.text = model?.username
        emailLabel.text = model?.email
        if let imageUrl = model?.imageUrl {
            profileImageView.loadAndCache(url: imageUrl)
        }
    }
    
    @objc private func changeProfileButtonPressed() {
//        present(imagePicker, animated: true)
        present(phPicker, animated: true)
    }
    
    @objc private func backButtonPressed() {
        
        navigationController?.popViewController(animated: true)
    }

    @objc private func ctaButtonPressed() {
        if !fullNameLabel.hasText {
            SnackBarDanger.make(in: self.view, message: "Full Name cannot be empty", duration: .lengthShort).show()
            return
        }
        if !usernameLabel.hasText {
            SnackBarDanger.make(in: self.view, message: "Username cannot be empty", duration: .lengthShort).show()
            return
        }
        if !emailLabel.hasText {
            SnackBarDanger.make(in: self.view, message: "Email cannot be empty", duration: .lengthShort).show()
            return
        }
        guard let fullName = fullNameLabel.text else { return }
        guard let username = usernameLabel.text else { return }
        guard let email = emailLabel.text else { return }
        var media: Media?
        if let image = profileImageView.image {
            media = Media(withImage: image, forKey: "image")
        }
        LoadingViewController.shared.startLoading(sourceVC: self)
        viewModel.updateProfile(
            fullName: fullName,
            username: username,
            email: email,
            media: media,
            completion: {
                DispatchQueue.main.async { [weak self] in
                    LoadingViewController.shared.stopLoading()
                    NotificationCenter.default.post(name: Notification.Name.profileUpdated, object: nil)
                    self?.navigationController?.popViewController(animated: true)
                }
            }, onError: { errorMessage in
                DispatchQueue.main.async { [weak self] in
                    LoadingViewController.shared.stopLoading()
                    guard let self = self else { return }
                    SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
                }
            })
    }
}

extension EditProfileViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let result = results.first else {
            print("Failed to get picked image")
            return
        }
        result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
            if error != nil {
                print("PHPickerViewController Error load object \(error?.localizedDescription ?? "")")
                return
            }
            print("Load object success")
            guard let image = object as? UIImage else { return }
            let resizedWidth: Double = 300
            let resizedHeight = resizedWidth * (image.size.height / image.size.width)
            print("Resized: \(resizedWidth) - \(resizedHeight)")
            let resized = ImageUtils.shared.resize(image: image, size: CGSize(width: resizedWidth, height: resizedHeight))
            DispatchQueue.main.async { [weak self] in
                self?.phPicker.dismiss(animated: true, completion: {
                    self?.profileImageView.image = resized
                })
                print("set image view profile success")
            }
        }
    }
}
