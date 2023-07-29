//
//  MenuHeaderView.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 26.06.2023.
//

import UIKit

class MenuHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var headerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerName.text = "menu".localized
    }
    
    func configure(name: String) {
        headerName.text = name
    }
}
