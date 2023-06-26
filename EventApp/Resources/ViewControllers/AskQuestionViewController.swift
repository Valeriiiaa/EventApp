//
//  AskQuestionViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 26.06.2023.
//

import UIKit

class AskQuestionViewController: UIViewController {

    @IBOutlet weak var languageTextField: TextField!
    @IBOutlet weak var typeTextField: TextField!
    @IBOutlet weak var textViewWriteMessage: UITextView!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendMessageButton.layer.cornerRadius = 12
        sendMessageButton.layer.masksToBounds = true
        textViewWriteMessage.layer.cornerRadius = 12
        textViewWriteMessage.layer.masksToBounds = true
        languageTextField.layer.cornerRadius = 12
        languageTextField.layer.masksToBounds = true
        typeTextField.layer.cornerRadius = 12
        typeTextField.layer.masksToBounds = true
        
        let type = UILabel()
        type.text = "Type"
        type.textColor = .black
        type.font = UIFont(name: "Montserrat-Regular", size: 16)
        typeTextField.leftView = type
        typeTextField.leftViewMode = .always
        let buttonType = UIButton(type: .custom)
        buttonType.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        buttonType.tintColor = .black
        typeTextField.rightView = buttonType
        typeTextField.rightViewMode = .always
       
        let language = UILabel()
        language.text = "Language"
        language.textColor = .black
        language.font = UIFont(name: "Montserrat-Regular", size: 16)
        languageTextField.leftView = language
        languageTextField.leftViewMode = .always
        let buttonLanguage = UIButton(type: .custom)
        buttonLanguage.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        buttonLanguage.tintColor = .black
        languageTextField.rightView = buttonLanguage
        languageTextField.rightViewMode = .always
    }
    
    @IBAction func didTapMenu(_ sender: Any) {
        let drawerController = DrawerMenuViewController()
            present(drawerController, animated: true)
    }
    
    
    @IBAction func sendMessageButtonDidTap(_ sender: Any) {
    }
    
}
