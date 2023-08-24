//
//  SettingsViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 25.06.2023.
//

import UIKit
import Combine
import IHProgressHUD

class SettingsViewController: BaseViewController {
    var itemsSection = [SectionModel]()
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var storage: UserDefaultsStorage = {
        UserDefaultsStorage()
    }()
    
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
        let attentionState = itemsSection[1].itemsInside.first(where: { $0.type == StateType.attentionSwitch.rawValue })
        attentionState?.stateModel.$state.sink(receiveValue: { [weak self] value in
            guard let self else { return }
            guard let value = value as? Bool else { return }
            self.storage.set(key: .showAttention, value: value)
        }).store(in: &subscriptions)
        
        let informationState = itemsSection[1].itemsInside.first(where: { $0.type == StateType.informationSwitch.rawValue })
        informationState?.stateModel.$state.sink(receiveValue: { [weak self] value in
            guard let self else { return }
            guard let value = value as? Bool else { return }
            self.storage.set(key: .showInformation, value: value)
        }).store(in: &subscriptions)
        let questionState = itemsSection[1].itemsInside.first(where: { $0.type == StateType.questionSwitch.rawValue })
        
        questionState?.stateModel.$state.sink(receiveValue: { [weak self] value in
            guard let self else { return }
            guard let value = value as? Bool else { return }
            self.storage.set(key: .showAQuestion, value: value)
        }).store(in: &subscriptions)
    }
    
    private func configureListData() {
        let name = "\(userManager?.userModel?.name_first ?? "") \(userManager?.userModel?.name_last ?? "")"
        let phone = userManager?.userModel?.phone ?? ""
        let showInformation = storage.get(key: .showInformation, defaultValue: true)
        let showAttention = storage.get(key: .showAttention, defaultValue: true)
        let showWarning = storage.get(key: .showWarning, defaultValue: true)
        let showQuestion = storage.get(key: .showAQuestion, defaultValue: true)
        itemsSection.append(
            .init(titleHeader: "personalInformation".localized,
                  itemsInside: [
                    TextFieldStateSectionModel(title: "name".localized,
                                               reuseId: CellManager.getCell(by: "CustomFieldCell"),
                                               state: name,
                                               type: .name,
                                               isEditable: false,
                                               keyboardType: .default),
                    TextFieldStateSectionModel(title: "login".localized,
                                               reuseId: CellManager.getCell(by: "CustomFieldCell"),
                                               state: phone,
                                               type: .phone,
                                               isEditable: true,
                                               didEndEditing: { [weak self] text in
                                                   guard let self else { return }
                                                   guard let text else { return }
                                                   guard self.userManager?.userModel?.phone != text else { return }
                                                   IHProgressHUD.show()
                                                   NetworkManager.shared.updatePhone(phone: text, completion: { result in
                                                       defer {
                                                           IHProgressHUD.dismiss()
                                                       }
                                                       switch result {
                                                       case .success(let success):
                                                           self.showAlert(title: "success".localized, message: "phoneUpdated".localized, okAction: nil)
                                                           self.userManager?.userModel?.phone = text
                                                       case .failure(let failure):
                                                           self.showAlert(title: "error".localized, message: "error".localized, okAction: nil)
                                                           self.tableView.reloadData()
                                                       }
                                                   })
                                               },
                                               keyboardType: .phonePad)
                  ])
        )
        itemsSection.append(
            .init(titleHeader: "notification".localized,
                  itemsInside: [
                    SwitcherStateSectionModel(title: "informationMessanges".localized,
                                              type: .informationSwitch,
                                              reuseId: CellManager.getCell(by: "SwitcherCell"),
                                              state: showInformation),
                    SwitcherStateSectionModel(title: "attentionMessanges".localized,
                                              type: .attentionSwitch,
                                              reuseId: CellManager.getCell(by: "SwitcherCell"),
                                              state: showAttention),
                    SwitcherStateSectionModel(title: "warningMessanges".localized,
                                              type: .warningSwitch,
                                              reuseId: CellManager.getCell(by: "SwitcherCell"),
                                              state: showWarning),
                    SwitcherStateSectionModel(title: "questionMessanges".localized,
                                              type: .questionSwitch,
                                              reuseId: CellManager.getCell(by: "SwitcherCell"),
                                              state: showQuestion)
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
