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
        tableView.register(UINib(nibName: CellManager.getCell(by: "MessageInfoCell"), bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "MessageInfoCell"))
        tableView.register(UINib(nibName: CellManager.getCell(by: "WarningMessagesCell"), bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "WarningMessagesCell"))
        tableView.register(UINib(nibName: CellManager.getCell(by: "InformationMessagesCell"), bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "InformationMessagesCell"))
        tableView.dataSource = self
        tableView.delegate = self

        backButton.setTitle("back".localized, for: .normal)
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
        case .archiveMessage(let archiveModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: "MessageInfoCell"), for: indexPath)
            (cell as? MessageInfoCell)?.configure(data: archiveModel.data, text: archiveModel.text, labelAttention: archiveModel.label, image: archiveModel.image)
            return cell
        case .warningMessage(let warningModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: "InformationMessagesCell"), for: indexPath)
            (cell as? InformationMessagesCell)?.configure(data: warningModel.data, image: warningModel.image, text: warningModel.text, infoMessage: warningModel.info)
            return cell
        default: return UITableViewCell()
        }
    }

    
    
}
