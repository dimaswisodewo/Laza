//
//  AddReviewViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 04/08/23.
//

import UIKit

protocol AddReviewViewControllerDelegate {
    func onSubmitReviewDone()
}

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
    
    @IBOutlet weak var slider: CustomSlider! {
        didSet {
            slider.value = slider.maximumValue
            slider.addTarget(self, action: #selector(setCurrentRatingLabel), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var currentRatingLabel: UILabel!
    
    @IBOutlet weak var submitReviewButton: UIButton! {
        didSet {
            submitReviewButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        }
    }
    
    var delegate: AddReviewViewControllerDelegate?
    private let viewModel = AddReviewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        currentRatingLabel.text = String(format: "%.0f", slider.maximumValue)
    }
    
    @objc private func setCurrentRatingLabel() {
        currentRatingLabel.text = String(format: "%.0f", slider.value)
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func submitButtonPressed() {
        
        if isPlaceholderActive {
            SnackBarDanger.make(in: self.view, message: "Text cannot be empty", duration: .lengthShort).show()
            return
        }
        
        guard let reviewText = textView.text else { return }
        
        viewModel.addReview(
            reviewText: reviewText,
            rating: slider.value,
            completion: { [weak self] in
                self?.delegate?.onSubmitReviewDone()
                self?.navigationController?.popViewController(animated: true)
            }, onError: { errorMessage in
                print(errorMessage)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
                }
            })
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
