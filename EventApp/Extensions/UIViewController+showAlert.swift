//
//  UIViewController+showAlert.swift
//  EventApp
//
//  Created by Kyrylo Chernov on 24.08.2023.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String, okAction: (() -> Void)?) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            okAction?()
        })
        alertViewController.addAction(okAction)
        present(alertViewController, animated: true)
    }
    
    func showAlert(title: String?, message: String, okTitle: String, cancelTitle: String, okAction: (() -> Void)?, cancelAction: (() -> Void)?) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle,  style: .destructive, handler: { _ in
            okAction?()
        })
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: { _ in
            cancelAction?()
        })
        alertViewController.addAction(okAction)
        alertViewController.addAction(cancelAction)
        present(alertViewController, animated: true)
    }
}
