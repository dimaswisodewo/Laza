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
        
        detectSignedAccountUsingUsername()
        
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
        if let token = DataPersistentManager.shared.getTokenFromKeychain() {
            refreshTokenIfNeeded(token: token) { [weak self] in
                self?.goToHomePage()
            }
        } else {
            goToLoginPage()
        }
    }
    
    private func refreshTokenIfNeeded(token: String, completion: @escaping () async -> Void) {
        Task {
            await SessionManager.shared.refreshTokenIfNeeded(token: token)
            await completion()
        }
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
        let vc = storyboard.instantiateViewController(withIdentifier: GetStartedViewController.identifier)
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: false)
        view.window?.windowScene?.keyWindow?.rootViewController = nav
    }
    
    private func goToHomePage() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: MainTabBarViewController.identifier)
        view.window?.windowScene?.keyWindow?.rootViewController = vc
    }
}
