//
//  SelectionCell.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 03.07.2023.
//

import UIKit

class SelectionCell: UITableViewCell {
    
    static let reuseIdentifier = "SelectionCell"
    
    @IBOutlet weak var selectionText: UILabel!
    @IBOutlet weak var checkMark: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    func configure(isSelected: Bool, selectionName: String) {
        selectionText.text = selectionName
        checkMark.isHidden = !isSelected
    }
}
