//
//  MenuHeaderView.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 26.06.2023.
//

import UIKit

class MenuHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var headerName: UILabel!
    
    func configure(name: String) {
        headerName.text = name
    }
}
