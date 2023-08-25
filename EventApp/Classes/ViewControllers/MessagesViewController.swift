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

class MessagesViewController: BaseViewController {
    @IBOutlet weak var goToWebsiteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var refreshControl: UIRefreshControl = {
        .init()
    }()
    
    private lazy var notificationPermissionManager: NotificationPermissionManager = {
        let notificationManager = AppDelegate.contaienr.resolve(NotificationManagerProtocol.self)!
        return .init(notificationManager: notificationManager)
    }()
    
    var messages = [MessagesModel]()
    
    private var notifications = [NotificationResponseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: CellManager.getCell(by: "MessageInfoCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "MessageInfoCell"))
        tableView.register(UINib(nibName: CellManager.getCell(by: "MainMessageCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "MainMessageCell"))
        tableView.dataSource = self
        tableView.delegate = self
        goToWebsiteButton.addTarget(self, action: #selector(goToWebSiteButtonDidTap), for: .touchUpInside)
        fetchProfile()
        goToWebsiteButton.setTitle("gooWebsite".localized, for: .normal)
        
        refreshControl.addTarget(self, action: #selector(update), for: UIControl.Event.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.addSubview(refreshControl)
        notificationPermissionManager.request()
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
            return MessagesModel(itemsInside: [.messageInfoCell(.init(image: image, type: item.type, text: item.text, data: ""))])
        })
        messages.append(contentsOf: newMessages)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func reconfigureMessages() {
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
            return MessagesModel(itemsInside: [.messageInfoCell(.init(image: image, type: item.type, text: item.text, data: ""))])
        })
        messages.append(contentsOf: newMessages)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc
    private func update(_ sender: AnyObject) {
        refreshControl.beginRefreshing()
        fetchMessages()
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
            defer {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
            }
            IHProgressHUD.dismiss()
            switch result {
            case .success(let success):
                let showInformation = UserDefaultsStorage.shared.get(key: .showInformation, defaultValue: true)
                let showAttention = UserDefaultsStorage.shared.get(key: .showAttention, defaultValue: true)
                let showWarning = UserDefaultsStorage.shared.get(key: .showWarning, defaultValue: true)
                let showQuestion = UserDefaultsStorage.shared.get(key: .showAQuestion, defaultValue: true)
                self.notifications = success.compactMap({ item in
                    if item.type == "Reminder" && !showAttention {
                        return nil
                    }
                    if ["News"].contains(item.type) && !showInformation {
                        return nil
                    } else if item.type == "Personal" && !showQuestion {
                        return nil
                    } else if !showWarning {
                        return nil
                    }
                    return item
                })
                self.configureMessages(notifications: self.notifications)
            case .failure(let failure):
                IHProgressHUD.showError(withStatus: failure.localizedDescription)
                IHProgressHUD.dismissWithDelay(0.5)
            }
        })
    }
    
    private func fetchProfile() {
//        guard self.userManager?.userModel == nil else { return }
        NetworkManager.shared.getProfile(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                if self.userManager?.userModel == nil {
                    self.userManager?.userModel = success
                }
                self.fetchMessages()
            case .failure(let failure):
                print("[test] \(failure.localizedDescription)")
            }
        })
    }
    
    private func archive(id: Int) {
        IHProgressHUD.show()
        NetworkManager.shared.archiveNotification(id: id, completion: { result in
            defer {
                IHProgressHUD.dismiss()
            }
            switch result {
            case .success:
                IHProgressHUD.showSuccesswithStatus("Done")
            case .failure(let failure):
                IHProgressHUD.showError(withStatus: failure.localizedDescription)
            }
        })
    }
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let archiveAction = UIContextualAction(style: .normal, title: "Archive", handler: { [weak self] _,_, completionHandler in
            guard let self else { return }
            self.tableView.beginUpdates()
            self.messages.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .none)
            self.tableView.endUpdates()
            let id = self.notifications[indexPath.row - 1].id
            self.archive(id: id)
            self.notifications.remove(at: indexPath.row - 1)
            completionHandler(true)
            self.reconfigureMessages()
        })
        archiveAction.backgroundColor = .orange
        return .init(actions: [archiveAction])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row > 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row > 0 else { return }
        let notification = notifications[indexPath.row - 1]

        let entrance = StoryboardFabric.getStoryboard(by: "Main").instantiateViewController(withIdentifier: "AlertMessageViewController")
        (entrance as? AlertMessageViewController)?.message = notification
        navigationController?.pushViewController(entrance, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = messages[indexPath.row]
        switch item.itemsInside.first {
        case .messageInfoCell(let messagesModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: "MessageInfoCell"), for: indexPath)
            (cell as? MessageInfoCell)?.configure(data: messagesModel.data, text: messagesModel.text, type: messagesModel.type, image: messagesModel.image)
            return cell
        case .mainMessageCell(let count):
            let cell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: "MainMessageCell"), for: indexPath)
            (cell as? MainMessageCell)?.configure(count: count)
            return cell
        default: return UITableViewCell()
        }
    }
}

