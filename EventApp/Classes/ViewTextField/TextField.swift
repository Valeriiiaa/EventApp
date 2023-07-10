//
//  TextField.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 26.06.2023.
//

import Foundation
import UIKit
           
class TextField: UITextField {

    var padding = UIEdgeInsets(top: 0, left: 120, bottom: 0, right: 80)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.leftViewRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20))
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.rightViewRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 20))
    }
}

