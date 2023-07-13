//
//  MessagesViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 23.06.2023.
//

import UIKit


class MessagesViewController: UIViewController {
    
    @IBOutlet weak var goToWebsiteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
   
    
    var messages = [MessagesModel(itemsInside: [.mainMessageCell]), MessagesModel(itemsInside: [.messageInfoCell(AlertMessagesModel(image: "warningMessage", label: false, text: "This is a very important message! Read it now!", data: "2 min ago"))]),MessagesModel(itemsInside: [.messageInfoCell(AlertMessagesModel(image: "attentionMessage", label: true, text: "Lorem ipsum dolor sit amet,consectetur adipiscing elit.", data: "1 day ago"))]), MessagesModel(itemsInside: [.messageInfoCell(AlertMessagesModel(image: "warningMessage", label: false, text: "This is a very important message! Read it now!", data: "1 day ago"))]), MessagesModel(itemsInside: [.messageInfoCell(AlertMessagesModel(image: "attentionMessage", label: true, text: "Lorem ipsum dolor sit amet,consectetur adipiscing elit.", data: "2 day ago"))])]
    
        override func viewDidLoad() {
        super.viewDidLoad()
            tableView.register(UINib(nibName: "MessageInfoCell" , bundle: nil), forCellReuseIdentifier: "MessageInfoCell")
            tableView.register(UINib(nibName: "MainMessageCell" , bundle: nil), forCellReuseIdentifier: "MainMessageCell")
        tableView.dataSource = self
        tableView.delegate = self
        goToWebsiteButton.addTarget(self, action: #selector(goToWebSiteButtonDidTap), for: .touchUpInside)
    }
    
    @objc
    func goToWebSiteButtonDidTap(_ sender: AnyObject) {
        UIApplication.shared.openURL(NSURL(string: "http://dev.effective-hc.com/")! as URL)
    }
    
    @IBAction func didTapMenu(_ sender: Any) {
        let drawerController = DrawerMenuViewController.shared
        present(drawerController, animated: true)
    }
    
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = messages[indexPath.row]
        switch item.itemsInside.first {
        case .messageInfoCell(let messagesModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageInfoCell", for: indexPath)
            (cell as? MessageInfoCell)?.configure(data: messagesModel.data, text: messagesModel.text, labelAttention: messagesModel.label, image: messagesModel.image)
            return cell
        case .mainMessageCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainMessageCell", for: indexPath)
            return cell
        default: return UITableViewCell()
        }
    }
}

