//
//  ArchiveViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 05.07.2023.
//

import UIKit

class ArchiveViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var messages = [MessageModel(itemsInside: [.archiveMessage(ArchiveMessagesModel(image: "attentionMessage", label: true, text: "Lorem ipsum dolor sit amet,consectetur adipiscing elit.", data: "2 min ago"))]), MessageModel(itemsInside: [.warningMessage(InformationMessageModel(imageMessage: "infoMessage", textMessage: "You have received an", dataMessage: "5 min ago", infoMessage: "Information message."))]), MessageModel(itemsInside: [.archiveMessage(ArchiveMessagesModel(image: "warningMessage", label: false, text: "This is a very important message! Read it now!", data: "1 day ago"))]), MessageModel(itemsInside: [.archiveMessage(ArchiveMessagesModel(image: "warningMessage", label: false, text: "This is a very important message! Read it now!", data: "2 day ago"))])]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MessageInfoCell", bundle: nil), forCellReuseIdentifier: "MessageInfoCell")
            tableView.register(UINib(nibName: "WarningMessagesCell", bundle: nil), forCellReuseIdentifier: "WarningMessagesCell")
        tableView.register(UINib(nibName: "InformationMessagesCell", bundle: nil), forCellReuseIdentifier: "InformationMessagesCell")
        tableView.dataSource = self
        tableView.delegate = self

        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = messages[indexPath.row]
        switch item.itemsInside.first {
        case .archiveMessage(let archiveModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageInfoCell", for: indexPath)
            (cell as? MessageInfoCell)?.configure(data: archiveModel.data, text: archiveModel.text, labelAttention: archiveModel.label, image: archiveModel.image)
            return cell
        case .warningMessage(let warningModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "InformationMessagesCell", for: indexPath)
            (cell as? InformationMessagesCell)?.configure(data: warningModel.data, image: warningModel.image, text: warningModel.text, infoMessage: warningModel.info)
            return cell
        default: return UITableViewCell()
        }
    }

    
    
}
