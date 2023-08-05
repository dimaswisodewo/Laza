//
//  VerificationCodeViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 05/08/23.
//

import UIKit

class VerificationCodeViewController: UIViewController {
    
    enum Tag: Int {
        case first = 1
        case second = 2
        case third = 3
        case fourth = 4
    }
    
    static let identifier = "VerificationCodeViewController"
    
    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var resendCodeButton: UIButton! {
        didSet {
            resendCodeButton.addTarget(self, action: #selector(resendButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var firstTextField: UITextField! {
        didSet {
            firstTextField.tag = Tag.first.rawValue
            firstTextField.text = nil
            firstTextField.keyboardType = .numberPad
            firstTextField.layer.cornerRadius = 14
            firstTextField.delegate = self
            firstTextField.addTarget(self, action: #selector(onTextFieldDidChange), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var secondTextField: UITextField! {
        didSet {
            secondTextField.tag = Tag.second.rawValue
            secondTextField.text = nil
            secondTextField.keyboardType = .numberPad
            secondTextField.layer.cornerRadius = 14
            secondTextField.delegate = self
            secondTextField.addTarget(self, action: #selector(onTextFieldDidChange), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var thirdTextField: UITextField! {
        didSet {
            thirdTextField.tag = Tag.third.rawValue
            thirdTextField.text = nil
            thirdTextField.keyboardType = .numberPad
            thirdTextField.layer.cornerRadius = 14
            thirdTextField.delegate = self
            thirdTextField.addTarget(self, action: #selector(onTextFieldDidChange), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var fourthTextField: UITextField! {
        didSet {
            fourthTextField.tag = Tag.third.rawValue
            fourthTextField.text = nil
            fourthTextField.keyboardType = .numberPad
            fourthTextField.layer.cornerRadius = 14
            fourthTextField.delegate = self
            fourthTextField.addTarget(self, action: #selector(onTextFieldDidChange), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    
    private let maxSeconds: Int = 62
    private var secondsRemaining: Int = 0
    
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer?.invalidate()
    }
    
    // End editing on touch began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func startTimer() {
        timer?.invalidate()
        secondsRemaining = maxSeconds
        setTimerLabel(secondsRemaining: secondsRemaining)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            self?.secondsRemaining -= 1
            self?.setTimerLabel(secondsRemaining: self?.secondsRemaining ?? 0)
            
            // Invalidate timer
            if (self!.secondsRemaining <= 0) {
                self?.timer?.invalidate()
            }
        })
    }
    
    private func setTimerLabel(secondsRemaining: Int) {
        if secondsRemaining > 0 {
            let time = secondsToHoursMinutesSeconds(secondsRemaining)
            
            let minute = time.1
            let second = time.2
            
            var minuteText = String(minute)
            if minute < 10 {
                minuteText.insert("0", at: minuteText.startIndex)
            }
            
            var secondText = String(second)
            if second < 10 {
                secondText.insert("0", at: secondText.startIndex)
            }
            
            timerLabel.text = "\(minuteText):\(secondText)"
        }
    }
    
    private func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func resendButtonPressed() {
        startTimer()
    }
    
    @objc private func onTextFieldDidChange(sender: UITextField) {
        
        if !sender.hasText {
            return
        }
        
        switch sender.tag {
        case Tag.first.rawValue:
            secondTextField.becomeFirstResponder()
        case Tag.second.rawValue:
            thirdTextField.becomeFirstResponder()
        case Tag.third.rawValue:
            fourthTextField.becomeFirstResponder()
        case Tag.fourth.rawValue:
            resignFirstResponder()
        default:
            break
        }
    }
    
    private func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension VerificationCodeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.hasText {
            textField.text = nil
        }
        return true
    }
}
