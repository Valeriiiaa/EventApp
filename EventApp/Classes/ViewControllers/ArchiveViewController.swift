//
//  ArchiveViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 05.07.2023.
//

import UIKit
import IHProgressHUD

struct ArchiveMessage {
    let id: Int
    let image: String
    let idMessage: Int?
    let title: String
    let text: String
    let link: String?
    let label: Bool
    let type: MessageType
    let textType: String
    let created_at: String
}

enum MessageType {
    case informationMessage
    case attentionMessage
    case warningMessage
}

class ArchiveViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var messages = [ArchiveMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: CellManager.getCell(by: "MessageInfoCell"), bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "MessageInfoCell"))
        tableView.register(UINib(nibName: CellManager.getCell(by: "WarningMessagesCell"), bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "WarningMessagesCell"))
        tableView.register(UINib(nibName: CellManager.getCell(by: "InformationMessagesCell"), bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "InformationMessagesCell"))
        tableView.dataSource = self
        tableView.delegate = self
        
        backButton.setTitle("back".localized, for: .normal)
        fetchArchive()
    }
    
    private func fetchArchive() {
        IHProgressHUD.show()
        NetworkManager.shared.loadArhivedNotifications(completion: { [weak self] result in
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
    
    private func configureMessages(notifications: [NotificationResponseModel]) {
        let newMessages = notifications.map({ item in
            var image = "warningMessage"
            var type = MessageType.informationMessage
            var label = false
            switch item.type {
            case "Reminder":
                image = "warningMessage"
                type = .warningMessage
            case "News", "Personal":
                image = "infoMessage"
                type = .informationMessage
            default:
                image = "attentionMessage"
                type = .attentionMessage
                label = true
            }
            return ArchiveMessage(id: item.id, image: image, idMessage: item.idMessage, title: item.title, text: item.text, link: item.link, label: label, type: type, textType: item.type, created_at: item.created_at)
        })
        messages.append(contentsOf: newMessages)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        DrawerMenuViewController.shared.back()
    }
    
    @IBAction func didTapMenu(_ sender: Any) {
        let drawerController = DrawerMenuViewController.shared
        present(drawerController, animated: true)
    }
}

extension ArchiveViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = messages[indexPath.row]
        guard notification.textType != "Ticket" else {
            DrawerMenuViewController.shared.openChatAskAQuestion(chatId: notification.id)
            return
        }

        let entrance = StoryboardFabric.getStoryboard(by: "Main").instantiateViewController(withIdentifier: "AlertMessageViewController")
        (entrance as? AlertMessageViewController)?.message = .init(id: notification.id, idMessage: notification.idMessage, text: notification.text, title: notification.title, link: notification.link, type: notification.textType, created_at: notification.created_at)
        navigationController?.pushViewController(entrance, animated: true)
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
        var cell = UITableViewCell()
        switch item.type {
        case .warningMessage:
            let tmpCell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: "InformationMessagesCell"), for: indexPath)
            (tmpCell as? InformationMessagesCell)?.configure(data: "", image: item.image, text: item.text, infoMessage: "")
            cell = tmpCell
        case .informationMessage, .attentionMessage:
            let tmpCell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: "MessageInfoCell"), for: indexPath)
            (tmpCell as? MessageInfoCell)?.configure(data: "", text: item.text, type: item.textType, image: item.image)
            cell = tmpCell
        }
        return cell
    }
}
