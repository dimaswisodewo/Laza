//
//  EditProfileViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 22/08/23.
//

import UIKit

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
    
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applyModel()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }
    
    func configure(model: Profile) {
        self.model = model
    }
    
    private func applyModel() {
        fullNameLabel.text = model?.fullName
        usernameLabel.text = model?.username
        emailLabel.text = model?.email
    }
    
    @objc private func changeProfileButtonPressed() {
        present(imagePicker, animated: true)
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
        viewModel.updateProfile(
            fullName: fullName,
            username: username,
            email: email,
            media: media,
            completion: {
                DispatchQueue.main.async { [weak self] in
                    NotificationCenter.default.post(name: Notification.Name.profileUpdated, object: nil)
                    self?.navigationController?.popViewController(animated: true)
                }
            }, onError: { errorMessage in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
                }
            })
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.originalImage] as? UIImage else { return }
        let resized = ImageUtils.shared.resize(image: pickedImage, size: CGSize(width: 300, height: 300))
        imagePicker.dismiss(animated: true) { [weak self] in
            self?.profileImageView.image = resized
        }
    }
}
