//
//  ViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 23.06.2023.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {

   
    @IBOutlet weak var bottomTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneTextField: TextField!
    @IBOutlet weak var getCodeButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.layer.cornerRadius = 12
        phoneTextField.layer.masksToBounds = true
        getCodeButton.layer.cornerRadius = 12
        getCodeButton.layer.masksToBounds = true
        phoneTextField.delegate = self
        
        let label = UILabel()
        label.text = "Phone"
        label.textColor = UIColor(red: 152/255, green: 152/255, blue: 152/255, alpha: 152/255)
        label.font = UIFont(name: "Montserrat-Light", size: 20)
        phoneTextField.leftView = label
        phoneTextField.leftViewMode = .always
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
}
    
    @objc func dismissKeyboard() {
       view.endEditing(true)
}
    
    @objc func dismissKeyboardPhone(_ sender: UITapGestureRecognizer) {
        let textFieldFrame = phoneTextField.convert(phoneTextField.bounds, to: view)
        let tapLocation = sender.location(in: view)
        
        if !textFieldFrame.contains(tapLocation) {
            view.endEditing(true)
        }
    }

    @IBAction func getCodeButtonDidTap(_ sender: Any) {
    }
    
   
    @IBAction func didNotGetCodeButtondidTap(_ sender: Any) {
    }
}

