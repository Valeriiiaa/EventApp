//
//  SettingsViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 25.06.2023.
//

import UIKit
import Combine

class SettingsViewController: BaseViewController {
    var itemsSection = [SectionModel]()
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureListData()
        bind()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: CellManager.getCell(by: "SwitcherCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "SwitcherCell"))
        tableView.register(UINib(nibName: CellManager.getCell(by: "CustomFieldCell"), bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "CustomFieldCell"))
        tableView.register(UINib(nibName: HeaderManager.getHeader(by: "SettingsHeaderView"), bundle: nil), forHeaderFooterViewReuseIdentifier: HeaderManager.getHeader(by: "SettingsHeaderView"))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        backButton.setTitle("back".localized, for: .normal)
    }
    
    private func bind() {
        let textFieldNameStateModel = itemsSection.first!.itemsInside.first
        textFieldNameStateModel?.stateModel.$state.sink(receiveValue: { [weak self] valuable in
            guard let text = valuable.value as? String else { return }
            guard let self else { return }
            let components = text.components(separatedBy: " ")
            guard let userModel = self.userManager?.userModel else {
                self.userManager?.userModel = .init(email: "", name_first: components.first ?? "", name_last: components.last ?? "", lang: "", phone: "")
                return
            }
            let userModelTmp = ProfileModelResponse(email: userModel.email, name_first: components.first ?? "", name_last: components.last ?? "", lang: userModel.lang, phone: userModel.phone)
            self.userManager?.userModel = userModelTmp
        }).store(in: &subscriptions)
    }
    
    private func configureListData() {
        let name = "\(userManager?.userModel?.name_first ?? "") \(userManager?.userModel?.name_last ?? "")"
        let phone = userManager?.userModel?.phone ?? ""
        itemsSection.append(
            .init(titleHeader: "personalInformation".localized,
                  itemsInside: [
                    TextFieldStateSectionModel(title: "name".localized,
                                               reuseId: CellManager.getCell(by: "CustomFieldCell"),
                                               state: name,
                                               type: .name,
                                               keyboardType: .default),
                    TextFieldStateSectionModel(title: "login".localized,
                                               reuseId: CellManager.getCell(by: "CustomFieldCell"),
                                               state: phone,
                                               type: .phone,
                                               keyboardType: .phonePad)
                  ])
        )
        itemsSection.append(
            .init(titleHeader: "notification".localized,
                  itemsInside: [
                    SwitcherStateSectionModel(title: "informationMessanges".localized,
                                              type: .informationSwitch,
                                              reuseId: CellManager.getCell(by: "SwitcherCell"),
                                              state: true),
                    SwitcherStateSectionModel(title: "attentionMessanges".localized,
                                              type: .attentionSwitch,
                                              reuseId: CellManager.getCell(by: "SwitcherCell"),
                                              state: true),
                    SwitcherStateSectionModel(title: "warningMessanges".localized,
                                              type: .warningSwitch,
                                              reuseId: CellManager.getCell(by: "SwitcherCell"),
                                              state: true),
                  ]))
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
        let cell = tableView.dequeueReusableCell(withIdentifier: model.reuseId, for: indexPath)
        switch StateType(rawValue: model.type) {
        case .name, .phone:
            (cell as? CustomFieldCell)?.configure(model: model as! TextFieldStateSectionModel)
        default:
            (cell as? SwitcherCell)?.configure(model: model as! SwitcherStateSectionModel)
        }
        return cell
    }
}
