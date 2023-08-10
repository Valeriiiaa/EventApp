//
//  DrawerMenuViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 24.06.2023.
//

import UIKit

class DrawerMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let shared = DrawerMenuViewController()
    
    public weak var drawerNavigationController: UINavigationController?
    
    private var previousVC: UIViewController?
    
    let transitionManager = DrawerTransitionManager()
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = transitionManager
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: CellManager.getCell(by: "MenuCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "MenuCell"))
        table.register(UINib(nibName:HeaderManager.getHeader(by: "MenuHeaderView"), bundle: nil), forHeaderFooterViewReuseIdentifier: HeaderManager.getHeader(by: "MenuHeaderView"))
        table.backgroundColor = nil
        table.separatorColor = .clear
        return table
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rightPopUp"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    @objc func closeButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    var menuItems = [MenuModel(header: "", itemsInside: MenuOptions.allCases)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 31).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    public func back() {
        drawerNavigationController?.setViewControllers([previousVC].compactMap({ $0 }), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 30, y: view.safeAreaInsets.top + 60, width: view.bounds.size.width - 30, height: view.bounds.size.height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: "MenuCell"), for: indexPath)
        let item = menuItems[indexPath.section].itemsInside[indexPath.row]
        (cell as? MenuCell)?.configure(label: item.description, picture: item.imageName)
        cell.backgroundColor = nil
        cell.contentView.backgroundColor = nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let itemSection = menuItems[section]
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MenuHeaderView")
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 71
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        previousVC = drawerNavigationController?.viewControllers.last
        switch indexPath.row {
        case 0: openHomeVC()
        case 1: openAskQuestionVC()
        case 2: openArchiveVC()
        case 3: openSettingsVC()
        case 4: openMainVC()
        default: print("ppp")
        }
    }
    
    private func openAskQuestionVC() {
        let entrance = StoryboardFabric.getStoryboard(by: "Main").instantiateViewController(withIdentifier: "AskQuestionViewController")
        guard !(drawerNavigationController?.viewControllers.last is AskQuestionViewController) else {
            dismiss(animated: true)
            return
        }
        drawerNavigationController?.viewControllers = [entrance]
        dismiss(animated: true)
    }
    
    public func openHomeVC() {
        let entrance = StoryboardFabric.getStoryboard(by: "Main").instantiateViewController(withIdentifier: "MessagesViewController")
        guard !(drawerNavigationController?.viewControllers.last is MessagesViewController) else {
            dismiss(animated: true)
            return
        }
        drawerNavigationController?.viewControllers = [entrance]
        dismiss(animated: true)
    }
    
    private func openArchiveVC() {
        let entrance = StoryboardFabric.getStoryboard(by: "Archive").instantiateViewController(withIdentifier: "ArchiveViewController")
        guard !(drawerNavigationController?.viewControllers.last is ArchiveViewController) else {
            dismiss(animated: true)
            return
        }
        drawerNavigationController?.viewControllers = [entrance]
        dismiss(animated: true)
    }
    
    private func openSettingsVC() {
        let entrance = StoryboardFabric.getStoryboard(by: "Main").instantiateViewController(withIdentifier: "SettingsViewController")
        guard !(drawerNavigationController?.viewControllers.last is SettingsViewController) else {
            dismiss(animated: true)
            return
        }
        drawerNavigationController?.viewControllers = [entrance]
        dismiss(animated: true)
    }
    
    private func openMainVC() {
        let entrance = StoryboardFabric.getStoryboard(by: "Main").instantiateViewController(withIdentifier: "MainViewController")
        guard !(drawerNavigationController?.viewControllers.last is MainViewController) else {
            dismiss(animated: true)
            return
        }
        NetworkManager.shared.logout()
        drawerNavigationController?.viewControllers = [entrance]
        dismiss(animated: true)
    }
    
}
