//
//  ViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 23.06.2023.
//

import UIKit
import IHProgressHUD


class MainViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var phoneTextField: TextField!
    @IBOutlet weak var getCodeButton: UIButton!
    @IBOutlet var bottomContainerConstraint: NSLayoutConstraint!
    @IBOutlet var logoTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.layer.cornerRadius = 12
        phoneTextField.layer.masksToBounds = true
        getCodeButton.layer.cornerRadius = 12
        getCodeButton.layer.masksToBounds = true
        phoneTextField.delegate = self
        
        phoneTextField.font = UIFont(name: "Montserrat-Light", size: 20)
    
           
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: phoneTextField.frame.height))
        
        let number = UILabel(frame: CGRect(x: 80, y: 0, width: 100, height: phoneTextField.frame.height))
        number.text = "+1"
        number.font = UIFont(name: "Montserrat-Light", size: 20)
        leftView.addSubview(number)
       
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: phoneTextField.frame.height))
        label.text = "Phone"
        label.textColor = UIColor(red: 152/255, green: 152/255, blue: 152/255, alpha: 152/255)
        label.font = UIFont(name: "Montserrat-Light", size: 20)
        leftView.addSubview(label)
        
        phoneTextField.leftView = leftView
        phoneTextField.leftViewMode = .always
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
   
    @objc func keyboardWillShow(notification: NSNotification) {
        bottomContainerConstraint.constant = 200
        logoTopConstraint.constant = -200
        self.view.layoutIfNeeded()
        self.view.layoutSubviews()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomContainerConstraint.constant = 0
        logoTopConstraint.constant = 15
        self.view.layoutIfNeeded()
        self.view.layoutSubviews()
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
        let entrance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessagesViewController")
        DrawerMenuViewController.shared.drawerNavigationController = navigationController
        navigationController?.pushViewController(entrance, animated: true)
        IHProgressHUD.show()
        IHProgressHUD.set(HudViewCustomBlurEffec: UIBlurEffect(style: .light))
        IHProgressHUD.setHUD(backgroundColor: UIColor.white)
        IHProgressHUD.dismissWithDelay(0.5)
        
    }
    
   
    @IBAction func didNotGetCodeButtondidTap(_ sender: Any) {
    }
}

