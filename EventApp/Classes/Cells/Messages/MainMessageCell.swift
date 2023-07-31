//
//  MainMessageCell.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 05.07.2023.
//

import UIKit

class MainMessageCell: UITableViewCell {

    @IBOutlet weak var youHaveMessagesLabel: UILabel!
    @IBOutlet weak var amountMessages: UILabel!
    @IBOutlet weak var backgroundMessagesView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        youHaveMessagesLabel.text = "YouHaveNew".localized
        amountMessages.text = "messages".localized
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: backgroundMessagesView.layer.cornerRadius = 12
            
            default: backgroundMessagesView.layer.cornerRadius = 24
                
        }
        
        backgroundMessagesView.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(count: Int) {
        amountMessages.text = "\(count) \("messages".localized)"
        backgroundMessagesView.backgroundColor = count == 0 ? .white : .red
    }

}
