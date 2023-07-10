//
//  SettingsViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 25.06.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var itemsSection = [SectionModel(titleHeader: "Personal Information", itemsInside: [.textField(TextFieldModel(text: "Name", keyboardType: .default)), .textField(TextFieldModel(text: "Login", keyboardType: .numberPad))]), SectionModel(titleHeader: "Notification", itemsInside: [.switcher(SwitcherModel(title: "Information messenges")), .switcher(SwitcherModel(title: "Attention messanges")), .switcher(SwitcherModel(title: "Warning messages"))])]

    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SwitcherCell" , bundle: nil), forCellReuseIdentifier: "SwitcherCell")
        tableView.register(UINib(nibName: "CustomFieldCell" , bundle: nil), forCellReuseIdentifier: "CustomFieldCell")
        tableView.register(UINib(nibName: "SettingsHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SettingsHeaderView")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
       view.endEditing(true)
}
    
    @IBAction func didTapMenu(_ sender: Any) {
        let drawerController = DrawerMenuViewController.shared
            present(drawerController, animated: true)
    }
   
    @IBAction func backButtonDidTap(_ sender: Any) {
        DrawerMenuViewController.shared.back()
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemsSection[section].itemsInside.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        itemsSection.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let itemSection = itemsSection[section]
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsHeaderView")
        (header as? SettingsHeaderView)?.configure(name: itemSection.titleHeader)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 71
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = itemsSection[indexPath.section].itemsInside[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: model.reusedId, for: indexPath)
        switch model {
        case .switcher(let switcherModel):
            (cell as? SwitcherCell)?.configure(text: switcherModel.title)
        case .textField(let textFieldModel):
            (cell as? CustomFieldCell)?.configure(text: textFieldModel.text, keyboardType: textFieldModel.keyboardType)
        }
        return cell
        }
}
