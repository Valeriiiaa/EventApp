//
//  DrawerMenuViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 24.06.2023.
//

import UIKit

class DrawerMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let transitionManager = DrawerTransitionManager()
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = transitionManager
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
}
    
    enum MenuOptions: String, CaseIterable {
        case home = "Home"
        case askQuestion = "Ask a Question"
        case archive = "Archive"
        case settings = "Settings"
        case logOut = "Log Out"
        
        var imageName: String {
            switch self {
            case .home:
                return "home"
            case .askQuestion:
                return "settings"
            case .archive:
                return "settings"
            case .settings:
                return "settings"
            case .logOut:
                return "settings"
            }
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = nil
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.size.width, height: view.bounds.size.height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
        cell.backgroundColor = nil
        cell.contentView.backgroundColor = nil
        cell.imageView?.image = UIImage(named: MenuOptions.allCases[indexPath.row].imageName)
        let font = UIFont.systemFont(ofSize: 25, weight: .light)
        cell.textLabel?.font = font
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


