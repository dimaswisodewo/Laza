//
//  ProfileViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 19/08/23.
//

import UIKit

class ProfileViewController: UIViewController {
    static let identifier = "ProfileViewController"
    
    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
            profileImageView.backgroundColor = .lightGray
            profileImageView.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var ctaButton: UIButton! {
        didSet {
            ctaButton.addTarget(self, action: #selector(ctaButtonPressed), for: .touchUpInside)
        }
    }
    
    private var model: Profile?
    
    private let viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applyModel()
        registerObserver()
        
        tabBarController?.tabBar.isHidden = true
    }
    
    // Remove observer to reload reviews
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.profileUpdated, object: nil)
    }
    
    // Register observer to reload reviews when there are new review added
    private func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(onProfileUpdated), name: Notification.Name.profileUpdated, object: nil)
    }
    
    func configure(model: Profile) {
        self.model = model
    }
    
    private func applyModel() {
        fullNameLabel.text = model?.fullName
        usernameLabel.text = model?.username
        emailLabel.text = model?.email
        if let imageUrl = model?.imageUrl {
            profileImageView.loadAndCache(url: imageUrl)
        }
    }
    
    private func getProfile() {
        viewModel.getProfile(completion: { profile in
            DispatchQueue.main.async { [weak self] in
                self?.model = profile
                self?.applyModel()
            }
        }, onError: { errorMessage in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
            }
        })
    }
    
    @objc private func onProfileUpdated() {
        getProfile()
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func ctaButtonPressed() {
        guard let model = self.model else { return }
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: EditProfileViewController.identifier) as? EditProfileViewController else { return }
        vc.configure(model: model)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func resfreshTokenButtonPressed(_ sender: UIButton) {
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
        Task {
            await SessionManager.shared.refreshTokenIfNeeded(token: token)
            print("Await done")
        }
    }
    
}
