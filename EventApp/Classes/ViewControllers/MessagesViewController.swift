//
//  MessagesViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 23.06.2023.
//

import UIKit
import Swinject
import Combine

class MessagesViewController: UIViewController {
    @IBOutlet weak var goToWebsiteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    
    private var subscriptions = Set<AnyCancellable>()
    
    lazy var userManager: UserManager? = {
        let container = AppDelegate.contaienr
        return container.resolve(UserManager.self)
    }()
    
    var messages = [MessagesModel(itemsInside: [.mainMessageCell]), MessagesModel(itemsInside: [.messageInfoCell(AlertMessagesModel(image: "warningMessage", label: false, text: "This is a very important message! Read it now!", data: "2 min ago"))]),MessagesModel(itemsInside: [.messageInfoCell(AlertMessagesModel(image: "attentionMessage", label: true, text: "Lorem ipsum dolor sit amet,consectetur adipiscing elit.", data: "1 day ago"))]), MessagesModel(itemsInside: [.messageInfoCell(AlertMessagesModel(image: "warningMessage", label: false, text: "This is a very important message! Read it now!", data: "1 day ago"))]), MessagesModel(itemsInside: [.messageInfoCell(AlertMessagesModel(image: "attentionMessage", label: true, text: "Lorem ipsum dolor sit amet,consectetur adipiscing elit.", data: "2 day ago"))])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: CellManager.getCell(by: "MessageInfoCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "MessageInfoCell"))
        tableView.register(UINib(nibName: CellManager.getCell(by: "MainMessageCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "MainMessageCell"))
        tableView.dataSource = self
        tableView.delegate = self
        goToWebsiteButton.addTarget(self, action: #selector(goToWebSiteButtonDidTap), for: .touchUpInside)
        fetchProfile()
        bind()
        
        goToWebsiteButton.setTitle("gooWebsite".localized, for: .normal)
    }
    
    private func bind() {
        userManager?.$userModel.receive(on: RunLoop.main).sink(receiveValue: { [weak self] model in
            guard let self else { return }
            guard let model else { return }
            self.nameLabel.text = "\(model.name_first) \(model.name_last)"
        }).store(in: &subscriptions)
    }
    
    @objc
    func goToWebSiteButtonDidTap(_ sender: AnyObject) {
        UIApplication.shared.openURL(NSURL(string: "http://dev.effective-hc.com/")! as URL)
    }
    
    @IBAction func didTapMenu(_ sender: Any) {
        let drawerController = DrawerMenuViewController.shared
        present(drawerController, animated: true)
    }
    
    private func fetchProfile() {
        NetworkManager.shared.getProfile(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.userManager?.userModel = success
            case .failure(let failure):
                print("[test] \(failure.localizedDescription)")
            }
        })
    }
    
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            tableView.beginUpdates()
            messages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)
            tableView.endUpdates()
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = messages[indexPath.row]
        switch item.itemsInside.first {
        case .messageInfoCell(let messagesModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: "MessageInfoCell"), for: indexPath)
            (cell as? MessageInfoCell)?.configure(data: messagesModel.data, text: messagesModel.text, labelAttention: messagesModel.label, image: messagesModel.image)
            return cell
        case .mainMessageCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: "MainMessageCell"), for: indexPath)
            return cell
        default: return UITableViewCell()
        }
    }
}

