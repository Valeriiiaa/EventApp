//
//  SelectionViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 03.07.2023.
//

import UIKit

class SelectionViewController: UIViewController {

    private var previousSelectedItem: SelectionModel?
    
    public var dataDidSelect: ((SelectionModel) -> Void)?
    
    public var allItems = [SelectionModel]() {
        didSet {
            items = allItems
            previousSelectedItem = allItems.first(where: { $0.isSelected })
        }
    }
    
    private var items = [SelectionModel]()
    
    @IBOutlet weak var selectionTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        selectionTableView.dataSource = self
        selectionTableView.delegate = self
        selectionTableView.register(UINib(nibName: CellManager.getCell(by: SelectionCell.reuseIdentifier), bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: SelectionCell.reuseIdentifier))
        searchBar.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                view.addGestureRecognizer(tapGesture)
    }
            
        @objc func dismissKeyboard() {
        view.endEditing(true)
   }
    
    @IBOutlet weak var searchBarDidTap: UISearchBar!
  }

extension SelectionViewController: UITableViewDelegate, UITableViewDataSource {

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    items.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: SelectionCell.reuseIdentifier), for: indexPath)
    let item = items[indexPath.row]
    (cell as? SelectionCell)?.configure(isSelected: item.isSelected, selectionName: item.name)
    return cell
}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].isSelected = true
        previousSelectedItem?.isSelected = false
        previousSelectedItem = items[indexPath.row]
        tableView.reloadData()
        let item = items[indexPath.row]
        dataDidSelect?(item)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        items[indexPath.row].isSelected = false
    }

}

extension SelectionViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.resignFirstResponder()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        defer { selectionTableView.reloadData() }
        guard !searchText.isEmpty else {
            items = allItems
            return
        }
        items = allItems.filter({ $0.name.localizedCaseInsensitiveContains(searchText) })
    }
}
