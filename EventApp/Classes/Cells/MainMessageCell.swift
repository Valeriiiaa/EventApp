//
//  MainMessageCell.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 05.07.2023.
//

import UIKit

class MainMessageCell: UITableViewCell {

    @IBOutlet weak var amountMessages: UILabel!
    @IBOutlet weak var backgroundMessagesView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundMessagesView.layer.cornerRadius = 12
        backgroundMessagesView.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
