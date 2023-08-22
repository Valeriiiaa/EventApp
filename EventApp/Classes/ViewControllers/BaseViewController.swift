//
//  BaseViewController.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 14.08.2023.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    public var subscriptions = Set<AnyCancellable>()
    
    public lazy var userManager: UserManager? = {
        let container = AppDelegate.contaienr
        return container.resolve(UserManager.self)
    }()
    
    override func viewDidLoad() {
        bind()
    }
    
    private func bind() {
        userManager?.$userModel.receive(on: RunLoop.main).sink(receiveValue: { [weak self] model in
            guard let self else { return }
            guard let model else { return }
            self.nameLabel.text = "\(model.name_first) \(model.name_last)"
        }).store(in: &subscriptions)
    }
}
