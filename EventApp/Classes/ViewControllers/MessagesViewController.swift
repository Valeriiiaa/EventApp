//
//  MessagesViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 23.06.2023.
//

import UIKit
import Swinject
import Combine
import IHProgressHUD

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

class MessagesViewController: BaseViewController {
    @IBOutlet weak var goToWebsiteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var messages = [MessagesModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: CellManager.getCell(by: "MessageInfoCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "MessageInfoCell"))
        tableView.register(UINib(nibName: CellManager.getCell(by: "MainMessageCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "MainMessageCell"))
        tableView.dataSource = self
        tableView.delegate = self
        goToWebsiteButton.addTarget(self, action: #selector(goToWebSiteButtonDidTap), for: .touchUpInside)
        fetchProfile()
        goToWebsiteButton.setTitle("gooWebsite".localized, for: .normal)
    }
    
    private func configureMessages(notifications: [NotificationResponseModel]) {
        messages = [MessagesModel(itemsInside: [.mainMessageCell(notifications.count)])]
        let newMessages = notifications.map({ item in
            var image = "warningMessage"
            switch item.type {
            case "Reminder":
                image = "warningMessage"
            case "News", "Personal":
                image = "infoMessage"
            default: image = "attentionMessage"
            }
            return MessagesModel(itemsInside: [.messageInfoCell(.init(image: image, label: true, text: item.text, data: ""))])
        })
        messages.append(contentsOf: newMessages)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc
    func goToWebSiteButtonDidTap(_ sender: AnyObject) {
        UIApplication.shared.openURL(NSURL(string: "http://effective-hc.com/")! as URL)
    }
    
    @IBAction func didTapMenu(_ sender: Any) {
        let drawerController = DrawerMenuViewController.shared
        present(drawerController, animated: true)
    }
    
    private func fetchMessages() {
        IHProgressHUD.show()
        NetworkManager.shared.loadNotifications(completion: { [weak self] result in
            guard let self else { return }
            IHProgressHUD.dismiss()
            switch result {
            case .success(let success):
                self.configureMessages(notifications: success)
            case .failure(let failure):
                IHProgressHUD.showError(withStatus: failure.localizedDescription)
            }
        })
    }
    
    private func fetchProfile() {
        NetworkManager.shared.getProfile(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.userManager?.userModel = success
                self.fetchMessages()
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
        return indexPath.row > 0
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
        case .mainMessageCell(let count):
            let cell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: "MainMessageCell"), for: indexPath)
            (cell as? MainMessageCell)?.configure(count: count)
            return cell
        default: return UITableViewCell()
        }
    }
}

