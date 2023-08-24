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
    @IBOutlet weak var goToLinkButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    public var message: NotificationResponseModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundMessageView.layer.cornerRadius = 20
        backgroundMessageView.layer.masksToBounds = true
        textMessageView.text = message.text
        dateMessageLabel.text = message.created_at.components(separatedBy: "T").first ?? ""
        goToLinkButton.layer.cornerRadius = 20
        goToLinkButton.layer.masksToBounds = true
        backButton.setTitle("back".localized, for: .normal)
    }
    
    @IBAction func goToLinkButtonDidTap(_ sender: Any) {
        guard let urlString = message.link else { return }
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func menuDidTap(_ sender: Any) {
        let drawerController = DrawerMenuViewController.shared
        present(drawerController, animated: true)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        DrawerMenuViewController.shared.back()
    }
    
    
}
