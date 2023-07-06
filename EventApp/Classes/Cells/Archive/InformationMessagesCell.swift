//
//  WarningMessagesCell.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 05.07.2023.
//

import UIKit

class InformationMessagesCell: UITableViewCell {

    @IBOutlet weak var dataText: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var messagesText: UILabel!
    @IBOutlet weak var imageMessages: UIImageView!
    @IBOutlet weak var backgroundMessagesView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundMessagesView.layer.cornerRadius = 12
        backgroundMessagesView.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    func configure(data: String, image: String, text: String, infoMessage: String) {
        dataText.text = data
        messagesText.text = text
        imageMessages.image = UIImage(named: image)
        informationLabel.text = infoMessage
        
    }
    
}
