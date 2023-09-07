//
//  StarterViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import UIKit
import GoogleSignIn

class StarterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        detectSignedAccountUsingUsername()
//        goToHomePage()
        
//        detectSignedGoogleAccount(onSignedIn: { [weak self] in
//            // Get google profile
//            self?.getGoogleProfile(completion: {
//                DispatchQueue.main.async {
//                    self?.goToLoginPage()
//                }
//            }, onError: { errorMessage in
//                print(errorMessage)
//                self?.detectSignedAccountUsingUsername()
//            })
//        }, onSignedOut: { [weak self] in
//            self?.detectSignedAccountUsingUsername()
//        })
    }
    
    private func detectSignedGoogleAccount(onSignedIn: @escaping () -> Void, onSignedOut: @escaping () -> Void) {
        // Attempt to restore the user's sign-in state
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
                print("Google account status: Signed out")
                onSignedOut()
            } else {
                // Show the app's signed-in state.
                print("Google account status: Signed in")
                onSignedIn()
            }
        }
    }
    
    private func detectSignedAccountUsingUsername() {
        // Is token exists
        if let _ = DataPersistentManager.shared.getTokenFromKeychain() {
            LoadingViewController.shared.startLoading(sourceVC: self)
            getProfile { profile in
                SessionManager.shared.setCurrentProfile(profile: profile)
                DispatchQueue.main.async { [weak self] in
                    LoadingViewController.shared.stopLoading()
                    self?.goToHomePage()
                }
            } onError: { [weak self] errorMessage in
                print("Get profile error \(errorMessage)")
                DispatchQueue.main.async {
                    LoadingViewController.shared.stopLoading()
                    self?.goToLoginPage()
                }
            }
            return
        }
        // Token does not exists
        goToLoginPage()
    }
    
    private func getGoogleProfile(completion: @escaping () -> Void, onError: @escaping (String) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else {
                onError(error!.localizedDescription)
                return
            }
            guard let signInResult = signInResult else {
                onError("Google sign in result is nil")
                return
            }

            let user = signInResult.user

//            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            
            print("Signed Google Profile: \(user)")
            
            completion()
        }
    }
    
    private func goToLoginPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: LoginViewController.identifier)
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: false)
        view.window?.windowScene?.keyWindow?.rootViewController = nav
    }
    
    private func goToHomePage() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: MainTabBarViewController.identifier)
        view.window?.windowScene?.keyWindow?.rootViewController = vc
    }
    
    private func getProfile(completion: @escaping (Profile) -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .UserProfile)
        
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
        
        NetworkManager.shared.sendRequestRefreshTokenIfNeeded(request: request) { result in
            switch result {
            case .success(let (data, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 200 {
                    // Login failed
                    onError("Error: \(httpResponse.statusCode)")
                    return
                }
                // Login success
                guard let data = data else { return }
                guard let profile = try? JSONDecoder().decode(ProfileResponse.self, from: data) else {
                    onError("Get profile success - Failed to decode")
                    return
                }
                completion(profile.data)
            case .failure(let error):
                onError(String(describing: error))
            }
        }
    }
}
