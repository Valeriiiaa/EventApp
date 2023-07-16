//
//  GetCodeView.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 13.07.2023.
//

import UIKit
import SGCodeTextField
import SwiftEntryKit
import IHProgressHUD

class GetCodeView: UIView {
    
    @IBOutlet weak var invalidCodeLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var pidCodeView: SGCodeTextField!
    
    public var okDidTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        okButton.layer.cornerRadius = 12
        okButton.layer.masksToBounds = true
        
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        pidCodeView.digitBackgroundColor = .clear
        pidCodeView.digitBackgroundColorEmpty = .clear
        pidCodeView.textColor = .label
        
        
        
    }
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        SwiftEntryKit.dismiss()
    }
   
    @IBAction func okButtonDidTap(_ sender: Any) {
        guard pidCodeView.text?.isEmpty == false else {
            pidCodeView?.layer.borderColor = UIColor.red.cgColor
            pidCodeView?.layer.borderWidth = 1
            pidCodeView.layoutSubviews()
            return
        }
        
        pidCodeView?.layer.borderWidth = 0
        
        guard pidCodeView.text?.count == 6  else {
            pidCodeView?.layer.borderColor = UIColor.red.cgColor
            pidCodeView?.layer.borderWidth = 1
            return
        }
            guard pidCodeView.text?.isEmpty == false,
              let pidCodeView = pidCodeView.text else {
            return
        }
        
        IHProgressHUD.show()
        okDidTap?()
    }
   
}


extension GetCodeView {
    class func fromNib() -> GetCodeView {
        return Bundle(for: GetCodeView.self).loadNibNamed(String(describing: GetCodeView.self), owner: nil, options: nil)![0] as! GetCodeView
    }
}
