//
//  SceneDelegate.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        // Set theme
        if let isDarkMode = DataPersistentManager.shared.getDarkModeConfigFromUserDefault() {
            print("is dark mode: ", isDarkMode)
            setEnableDarkMode(isEnabled: isDarkMode)
        }
        
        // Detect signed account
        detectSignedAccount(onSignedIn: {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: MainTabBarViewController.identifier)
            let nav = UINavigationController(rootViewController: homeVC)
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
        }, onSignedOut: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: LoginViewController.identifier)
            let nav = UINavigationController(rootViewController: loginVC)
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
        })
    }
    
    private func detectSignedAccount(onSignedIn: () -> Void, onSignedOut: () -> Void) {
        guard let profile = DataPersistentManager.shared.getProfileFromKeychain() else {
            // Profile does not exists
            onSignedOut()
            return
        }
        // Profile does exists
        SessionManager.shared.setCurrentProfile(profile: profile)
        onSignedIn()
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

    private func setEnableDarkMode(isEnabled: Bool) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let appDelegate = windowScene.windows.first else { return }
        appDelegate.overrideUserInterfaceStyle = isEnabled ? .dark : .light
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

