//
//  CustomFieldCell.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 25.06.2023.
//

import UIKit

class CustomFieldCell: UITableViewCell {
   
    @IBOutlet weak var textField: TextField!
    
    private var label: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        
        textField.padding = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 80)
        textField.font = UIFont(name: "Montserrat", size: 18)
        
        let label = UILabel(frame: CGRect(x: 80, y: 0, width: 100, height: textField.frame.height))
        label.font = UIFont(name: "Montserrat", size: 15)
        label.textColor = UIColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1)
        textField.leftView = label
        textField.leftViewMode = .always
        self.label = label
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
}
    
    func configure(text: String, keyboardType: UIKeyboardType) {
        label?.text = text
        textField.keyboardType = keyboardType
    }

}
