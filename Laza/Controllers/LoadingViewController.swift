//
//  LoadingViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 06/09/23.
//

import UIKit

class LoadingViewController: UIViewController {
    
    static let shared = LoadingViewController()
    
    private var loadingActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        indicator.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin,
            .flexibleTopMargin, .flexibleBottomMargin
        ]
        return indicator
    }()
    
    private var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.5
        blurEffectView.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
        return blurEffectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        // Add the blurEffectView with the same size as view
        blurEffectView.frame = self.view.bounds
        view.insertSubview(blurEffectView, at: 0)
        
        // Add the loadingActivityIndicator in the center of view
        loadingActivityIndicator.center = CGPoint(
            x: view.bounds.midX,
            y: view.bounds.midY
        )
        view.addSubview(loadingActivityIndicator)
    }
    
    func startLoading(sourceVC: UIViewController) {
        // Animate loadingVC over the existing views on screen
        LoadingViewController.shared.modalPresentationStyle = .overCurrentContext
        // Animate loadingVC with a fade in animation
        LoadingViewController.shared.modalTransitionStyle = .crossDissolve
        
        LoadingViewController.shared.loadingActivityIndicator.startAnimating()
        
        sourceVC.present(LoadingViewController.shared, animated: true, completion: nil)
    }
    
    func stopLoading(completion: (() -> Void)? = nil) {
        LoadingViewController.shared.dismiss(animated: true, completion: completion)
    }
}
