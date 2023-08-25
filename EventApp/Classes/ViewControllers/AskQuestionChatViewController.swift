//
//  AskQuestionChatViewController.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 24.08.2023.
//

import UIKit
import IHProgressHUD

class AskQuestionChatViewController: BaseViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    var messages = [ChatMessageModel]()
    
    private lazy var refreshControl: UIRefreshControl = {
        .init()
    }()
    
    public var chatId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.register(UINib(nibName: CellManager.getCell(by: "LeftMessagesCell"), bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "LeftMessagesCell"))
        chatTableView.register(UINib(nibName: CellManager.getCell(by: "RightMessagesCell"), bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "RightMessagesCell"))
        chatTableView.delegate = self
        chatTableView.dataSource = self
        sendButton.layer.cornerRadius = 10
        sendButton.layer.masksToBounds = true
        refreshControl.addTarget(self, action: #selector(update), for: UIControl.Event.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        chatTableView.addSubview(refreshControl)
        loadMessages()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        view.endEditing(true)
    }
    
    private func loadMessages() {
        guard let chatId else { return }
        IHProgressHUD.show()
        NetworkManager.shared.getMessages(chatId: chatId, completion: { [weak self] result in
            guard let self else { return }
            defer {
                self.refreshControl.endRefreshing()
                IHProgressHUD.dismiss()
            }
            switch result {
            case .success(let success):
                self.messages = success.map({ .init(text: $0.text, date: $0.date, isUserMessage: $0.isUserMessage) })
                    .reversed()
                self.chatTableView.reloadData()
                self.chatTableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: false)
            case .failure(let failure):
                self.showAlert(title: "error".localized, message: failure.localizedDescription, okAction: nil)
            }
        })
    }
    
    @objc
    private func update(_ sender: AnyObject) {
        refreshControl.beginRefreshing()
        loadMessages()
    }
    
    @IBAction func sendDidTap(_ sender: Any) {
        guard let text = messageTextField.text,
              !text.isEmpty else { return }
        messageTextField.text = nil
        view.endEditing(true)
        IHProgressHUD.show()
        NetworkManager.shared.sendMessage(chatId: chatId, message: text, completion: { [weak self] result in
            guard let self else { return }
            defer {
                IHProgressHUD.dismiss()
            }
            switch result {
            case .success:
                self.messages.append(.init(text: text, date: "", isUserMessage: true))
                self.chatTableView.reloadData()
                self.chatTableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
            case .failure(let error):
                self.showAlert(title: "error".localized, message: error.localizedDescription, okAction: nil)
                self.messageTextField.text = text
            }
        })
    }
    
    @IBAction func menuDidTap(_ sender: Any) {
        let drawerController = DrawerMenuViewController.shared
        present(drawerController, animated: true)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        DrawerMenuViewController.shared.back()
    }
}

extension AskQuestionChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cellIdentifier = message.isUserMessage ? CellManager.getCell(by: "RightMessagesCell") : CellManager.getCell(by: "LeftMessagesCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let date = message.date.components(separatedBy: "T").first ?? ""
        (cell as? MessageCell)?.configure(text: message.text, time: date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
