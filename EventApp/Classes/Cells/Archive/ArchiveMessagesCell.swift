//
//  ArchiveMessagesCell.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 05.07.2023.
//

import UIKit

class ArchiveMessagesCell: UITableViewCell {

    @IBOutlet weak var massagesImage: UIImageView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var messagesText: UILabel!
    @IBOutlet weak var attentionLabel: UILabel!
    @IBOutlet weak var backgroundArchiveView: UIView!
    @IBOutlet weak var messagesConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundArchiveView.layer.cornerRadius = 12
        backgroundArchiveView.layer.masksToBounds = true
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
   
    func configure(data: String, text: String, labelAttention: Bool, image: String) {
        dataLabel.text = data
        messagesText.text = text
        self.attentionLabel.isHidden = !labelAttention
        massagesImage.image = UIImage(named: image)
        
        if !self.attentionLabel.isHidden {
            messagesConstraint.priority = .defaultHigh
        } else {
            messagesConstraint.priority = .defaultLow
        }
    }

}
