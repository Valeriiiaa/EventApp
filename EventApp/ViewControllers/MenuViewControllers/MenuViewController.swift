//
//  MenuViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 24.06.2023.
//

import UIKit

class MenuViewController: UIViewController {

    let transitionManager = DrawerTransitionManager()
    init() {
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = transitionManager
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
    }
    


}
