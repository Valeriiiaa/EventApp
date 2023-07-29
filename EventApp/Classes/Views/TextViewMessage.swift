//
//  TextViewMessage.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 05.07.2023.
//

import UIKit

class OverlayView: UIView {
    let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "writeMessage".localized
        label.font = UIFont(name: "Montserrat", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
   
    private func setupViews() {
            addSubview(messageLabel)
            NSLayoutConstraint.activate([
//                messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
//                messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
//                messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
                messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                messageLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30)
            ])
        }
    }
