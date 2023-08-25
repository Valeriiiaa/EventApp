//
//  LeftMessagesCell.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 26.07.2023.
//

import UIKit

class LeftMessagesCell: UITableViewCell, MessageCell {
    @IBOutlet weak var backgroundMessageView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundMessageView.layer.cornerRadius = 20
        backgroundMessageView.layer.masksToBounds = true
    }

    func configure(text: String, time: String) {
        messageText.text = text
        timeLabel.text = time
    }
}
