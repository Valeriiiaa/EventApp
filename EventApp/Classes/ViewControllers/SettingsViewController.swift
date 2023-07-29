//
//  SettingsViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 25.06.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var itemsSection = [SectionModel(titleHeader: "personalInformation".localized, itemsInside: [.textField(TextFieldModel(text: "name".localized, keyboardType: .default)), .textField(TextFieldModel(text: "login".localized, keyboardType: .numberPad))]), SectionModel(titleHeader: "notification".localized, itemsInside: [.switcher(SwitcherModel(title: "informationMessanges".localized)), .switcher(SwitcherModel(title: "attentionMessanges".localized)), .switcher(SwitcherModel(title: "warningMessanges".localized))])]

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: CellManager.getCell(by: "SwitcherCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "SwitcherCell"))
        tableView.register(UINib(nibName: CellManager.getCell(by: "CustomFieldCell"), bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "CustomFieldCell"))
        tableView.register(UINib(nibName: HeaderManager.getHeader(by: "SettingsHeaderView"), bundle: nil), forHeaderFooterViewReuseIdentifier: HeaderManager.getHeader(by: "SettingsHeaderView"))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        backButton.setTitle("back".localized, for: .normal)
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
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CellManager.getCell(by: "SettingsHeaderView"))
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
