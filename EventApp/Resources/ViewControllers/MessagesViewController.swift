//
//  MessagesViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 23.06.2023.
//

import UIKit



class MessagesViewController: UIViewController {
    
    @IBOutlet weak var backgroundMessagesView: UIView!
    
        override func viewDidLoad() {
        super.viewDidLoad()
        backgroundMessagesView.layer.cornerRadius = 12
        backgroundMessagesView.layer.masksToBounds = true
    }
    
    
    @IBAction func didTapMenu(_ sender: Any) {
        let drawerController = DrawerMenuViewController()
            present(drawerController, animated: true)
    }
    
    

}
