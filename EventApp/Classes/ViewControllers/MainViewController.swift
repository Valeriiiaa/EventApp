//
//  ViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 23.06.2023.
//

import UIKit
import IHProgressHUD
import SwiftEntryKit
import Swinject

class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var didNotGetCodeButton: UIButton!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var phoneTextField: TextField!
    @IBOutlet weak var getCodeButton: UIButton!
    @IBOutlet var bottomContainerConstraint: NSLayoutConstraint!
    @IBOutlet var logoTopConstraint: NSLayoutConstraint!
    
    private var labelFontSize: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            phoneTextField.layer.cornerRadius = 12
            getCodeButton.layer.cornerRadius = 12
            phoneTextField.font = UIFont(name: "Montserrat-Light", size: 20)
            imageView.layer.cornerRadius = 12
            
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: phoneTextField.frame.height))
            
            let number = UILabel(frame: CGRect(x: 80, y: 0, width: 100, height: phoneTextField.frame.height))
            number.text = "+1"
            number.font = UIFont(name: "Montserrat-Light", size: labelFontSize)
            leftView.addSubview(number)
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: phoneTextField.frame.height))
            label.text = "Phone"
            label.textColor = UIColor(red: 152/255, green: 152/255, blue: 152/255, alpha: 152/255)
            label.font = UIFont(name: "Montserrat-Light", size: labelFontSize)
            leftView.addSubview(label)
            
            phoneTextField.leftView = leftView
            
        default:
            phoneTextField.layer.cornerRadius = 24
            getCodeButton.layer.cornerRadius = 24
            imageView.layer.cornerRadius = 24
            labelFontSize = 35
            
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 180, height: phoneTextField.frame.height))
            
            let number = UILabel(frame: CGRect(x: 120, y: 0, width: 80, height: phoneTextField.frame.height))
            number.text = "+1"
            number.font = UIFont(name: "Montserrat-Light", size: labelFontSize)
            leftView.addSubview(number)
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: phoneTextField.frame.height))
            label.text = "Phone"
            label.textColor = UIColor(red: 152/255, green: 152/255, blue: 152/255, alpha: 152/255)
            label.font = UIFont(name: "Montserrat-Light", size: labelFontSize)
            leftView.addSubview(label)
            phoneTextField.padding = .init(top: 0, left: 180, bottom: 0, right: 20)
            phoneTextField.leftView = leftView
        }
        imageView.layer.masksToBounds = true
        phoneTextField.layer.masksToBounds = true
        getCodeButton.layer.masksToBounds = true
        phoneTextField.delegate = self
        phoneTextField.returnKeyType = .done
        
        didNotGetCodeButton.setTitle("didGetTheCode".localized, for: .normal)
        labelText.text = "effectiveHomeCareMassager".localized
        getCodeButton.setTitle("getTheCode".localized, for: .normal)
        
        phoneTextField.font = UIFont(name: "Montserrat-Light", size: labelFontSize)
        
        
        phoneTextField.leftViewMode = .always
        
        setupToolbar()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupToolbar(){
        let bar = UIToolbar()
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(getCodeKeyoboard))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()
        
        phoneTextField.inputAccessoryView = bar
    }
    
    @objc func getCodeKeyoboard(){
        getCode()
    }
    
    
    private func showPopup() {
        let view = GetCodeView.fromNib()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.9).isActive = true
            
        default:
            view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.5).isActive = true
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.okDidTap = { [weak self, weak view] in
            guard let view else { return }
            guard let self else { return }
            NetworkManager.shared.requestWithCode(phone: self.phoneTextField.text!, code: view.pidCodeView.text!, comletion: { data in
                switch data {
                case .success(let success):
                    self.registerDependency(token: success)
                    DispatchQueue.main.async {
                        SwiftEntryKit.dismiss()
                        self.pushMessageController()
                    }
                case .failure(let failure):
                    DispatchQueue.main.async {
                        view.invalidCodeLabel.isHidden = false
                    }
                }
            })
        }
        
        var attributes = EKAttributes.centerFloat
        attributes.displayDuration = .infinity
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .forward
        attributes.screenBackground = .color(color: EKColor(UIColor.black.withAlphaComponent(0.4)))
        SwiftEntryKit.display(entry: view, using: attributes)
    }
    
    private func registerDependency(token: String) {
        let container = AppDelegate.contaienr
        UserDefaultsStorage.shared.set(key: .token, value: token)
        container.register(UserManager.self, factory: { r in
            print("registered")
            return UserManager(token: token)
        }).inObjectScope(.container)
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
    
    func pushMessageController() {
        let entrance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MessagesViewController")
        navigationController?.pushViewController(entrance, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        getCode()
        return true
    }
    
    @IBAction func getCodeButtonDidTap(_ sender: Any) {
        getCode()
    }
    
    @IBAction func didNotGetCodeButtondidTap(_ sender: Any) {
        getCode()
    }
    
    func getCode() {
        guard let text = phoneTextField.text else { return }
        if !text.isEmpty {
            view.endEditing(true)
            IHProgressHUD.show()
            NetworkManager.shared.requestCode(phone: text, completion: { [weak self] data in
                guard let self else { return }
                IHProgressHUD.dismiss()
                if data == true {
                    DispatchQueue.main.async {
                        self.showPopup()
                    }
                } else {
                }
            })
        } else {
        }
    }
}

