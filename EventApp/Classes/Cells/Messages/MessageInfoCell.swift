//
//  MessageInfoCell.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 05.07.2023.
//

import UIKit

class MessageInfoCell: UITableViewCell {

    
    @IBOutlet weak var messageConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundMessageView: UIView!
    @IBOutlet weak var meesageTime: UILabel!
    @IBOutlet weak var textMessageView: UILabel!
    @IBOutlet weak var labelAttention: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: backgroundMessageView.layer.cornerRadius = 12
            
            default: backgroundMessageView.layer.cornerRadius = 12
                
        }
       
        backgroundMessageView.layer.masksToBounds = true
        

       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
   
    func configure(data: String, text: String, type: String, image: String) {
        meesageTime.text = data
        textMessageView.text = text
        labelAttention.text = type
        messageImage.image = UIImage(named: image)
        
        if !self.labelAttention.isHidden {
            messageConstraint.priority = .defaultHigh
        } else {
            messageConstraint.priority = .defaultLow
        }
        layoutIfNeeded()
        layoutSubviews()
    }
}
