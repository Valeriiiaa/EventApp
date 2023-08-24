//
//  AlertMessageViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 24.08.2023.
//

import UIKit

class AlertMessageViewController: UIViewController {
    
    @IBOutlet weak var dateMessageLabel: UILabel!
    @IBOutlet weak var textMessageView: UITextView!
    @IBOutlet weak var backgroundMessageView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundMessageView.layer.cornerRadius = 20
        backgroundMessageView.layer.masksToBounds = true
        
    }
    
    @IBAction func goToLinkButtonDidTap(_ sender: Any) {
    }
    
    @IBAction func menuDidTap(_ sender: Any) {
        let drawerController = DrawerMenuViewController.shared
        present(drawerController, animated: true)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        DrawerMenuViewController.shared.back()
    }
    
    
}
