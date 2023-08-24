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
    private var textFiledModel: TextFieldStateSectionModel?
    
    public var didEndEditing: ((String?) -> Void)?
    
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
        self.textField.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(model: TextFieldStateSectionModel) {
        textFiledModel = model
        label?.text = model.title
        textField.keyboardType = model.keyboardType
        guard let state = model.stateModel.state as? String else { return }
        textField.text = state
        textField.isEnabled = model.isEditable
    }
}

extension CustomFieldCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textFiledModel?.didEndEditing?(textField.text)
    }
}
