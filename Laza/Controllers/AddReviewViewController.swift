//
//  AddReviewViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 04/08/23.
//

import UIKit

class AddReviewViewController: UIViewController {
    
    static let identifier = "AddReviewViewController"
    
    private var isPlaceholderActive = true
    
    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.delegate = self
            textView.autocorrectionType = .no
            textView.autocapitalizationType = .sentences
            textView.layer.cornerRadius = 20
            textView.contentInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            // Setup placeholder
            textView.text = "How was your experience..."
            isPlaceholderActive = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    // End editing on touch began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension AddReviewViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isPlaceholderActive {
            textView.text = nil
            isPlaceholderActive = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "How was your experience..."
            isPlaceholderActive = true
        }
    }
}
