//
//  ViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 23.06.2023.
//

import UIKit

class MainViewController: UIViewController {

   
    @IBOutlet weak var phoneTextField: TextField!
    @IBOutlet weak var getCodeButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.layer.cornerRadius = 12
        phoneTextField.layer.masksToBounds = true
        getCodeButton.layer.cornerRadius = 12
        getCodeButton.layer.masksToBounds = true
        
        let label = UILabel()
        label.text = "Phone"
        label.textColor = UIColor(red: 152/255, green: 152/255, blue: 152/255, alpha: 152/255)
        label.font = UIFont(name: "Montserrat-Light", size: 20)
        phoneTextField.leftView = label
        phoneTextField.leftViewMode = .always
       
    }

    @IBAction func getCodeButtonDidTap(_ sender: Any) {
    }
    
   
    @IBAction func didNotGetCodeButtondidTap(_ sender: Any) {
    }
}

