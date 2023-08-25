//
//  RightMessagesCell.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 26.07.2023.
//

import UIKit

class RightMessagesCell: UITableViewCell, MessageCell {
    @IBOutlet weak var backgroundViewMessages: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var textMessaging: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundViewMessages.layer.cornerRadius = 20
        backgroundViewMessages.layer.masksToBounds = true
    }
    
    func configure(text: String, time: String) {
        textMessaging.text = text
        durationLabel.text = time
    }
}
