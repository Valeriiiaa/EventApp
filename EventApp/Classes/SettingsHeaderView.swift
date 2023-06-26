//
//  SettingsHeaderView.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 25.06.2023.
//

import UIKit

class SettingsHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var headerName: UILabel!
    
    func configure(name: String) {
        headerName.text = name
        }

}
