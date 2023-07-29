//
//  ViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    static let identifier = "OnboardingViewController"
    
    @IBOutlet weak var menButton: RoundedButton! {
        didSet {
            menButton.addTarget(self, action: #selector(goToGetStarted), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var womenButton: RoundedButton! {
        didSet {
            womenButton.addTarget(self, action: #selector(goToGetStarted), for: .touchUpInside)
        }
    }
    
    private lazy var leftTopCircle: UIView = {
        let screenWidth = view.bounds.width
        let view = createEllipseGradientView(width: screenWidth * 2, height: screenWidth * 2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DataPersistentManager.shared.isUserDataExistsInUserDefaults() {
            print("masuk")
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: MainTabBarViewController.identifier)
//            view.window?.windowScene?.keyWindow?.rootViewController = vc
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        view.addSubview(leftTopCircle)
        
        leftTopCircle.superview?.sendSubviewToBack(leftTopCircle)
        
        setupCircleGradientConstraints()
    }
    
    @objc private func goToGetStarted() {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: GetStartedViewController.identifier) else { return }
                
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupCircleGradientConstraints() {
        let screenWidth = view.bounds.width
        // Left top
        NSLayoutConstraint.activate([
            leftTopCircle.topAnchor.constraint(equalTo: view.topAnchor, constant: -screenWidth),
            leftTopCircle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -screenWidth)
        ])
    }

    private func createEllipseGradientView(width: CGFloat, height: CGFloat) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        view.layer.cornerRadius = view.bounds.width / 2
        view.isUserInteractionEnabled = false
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.cornerRadius = view.layer.cornerRadius
        gradientLayer.type = .radial
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0.25).cgColor,
            UIColor.clear.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.position = view.center
        
        view.layer.addSublayer(gradientLayer)
        
        return view
    }
}

