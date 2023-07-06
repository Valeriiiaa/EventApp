//
//  AskQuestionViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 26.06.2023.
//

import UIKit

class AskQuestionViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var backgroundLanguageView: UIView!
    @IBOutlet weak var backgroundTypeView: UIView!
    @IBOutlet weak var textViewMessage: UITextView!
    @IBOutlet weak var textViewWriteMessage: UITextView!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    var overlayView: OverlayView!
   
    private var type = [TypeModel]()
    private var language = [LanguageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendMessageButton.layer.cornerRadius = 12
        sendMessageButton.layer.masksToBounds = true
        textViewWriteMessage.layer.cornerRadius = 12
        textViewWriteMessage.layer.masksToBounds = true
        backgroundLanguageView.layer.cornerRadius = 12
        backgroundLanguageView.layer.masksToBounds = true
        backgroundTypeView.layer.cornerRadius = 12
        backgroundTypeView.layer.masksToBounds = true
        textViewMessage.delegate = self
        
        setupOverlayView()
}

    func setupOverlayView() {
            overlayView = OverlayView(frame: textViewWriteMessage.bounds)
            overlayView.isUserInteractionEnabled = false
            textViewWriteMessage.addSubview(overlayView)
        }
    
    func showOverlayView(_ show: Bool) {
        overlayView.isHidden = !show
        if show {
            textViewWriteMessage.bringSubviewToFront(overlayView)
        } else {
            textViewWriteMessage.sendSubviewToBack(overlayView)
        }
    }

    @objc func dismissKeyboard() {
        textViewWriteMessage.resignFirstResponder()
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        if textViewWriteMessage.text.isEmpty {
            showOverlayView(false)
        }
        return true
}
    
    func textViewDidEndEditing(_ textView: UITextView) {
        view.gestureRecognizers?.forEach {
            if let tapGesture = $0 as? UITapGestureRecognizer {
                view.removeGestureRecognizer(tapGesture)
    }
            if textViewWriteMessage.text.isEmpty {
                showOverlayView(true)
            }
        }
    }
    
    @objc
    @IBAction func typeDidTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectionViewController")
        
        (vc as? SelectionViewController)?.allItems = type.map({ .init(key: $0.key, name: $0.text, isSelected: false) })
        
        (vc as? SelectionViewController)?.dataDidSelect = { [weak self] selectedData in
            guard let self else { return }
            guard let type = self.type.first(where: { $0.key == selectedData.key }) else { return }
           
        }
       present(vc, animated: true)
    }
    
    @objc
    @IBAction private func languageDidTap(_ sender: UIGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectionViewController")
        (vc as? SelectionViewController)?.allItems = language.map({ .init(key: $0.key, name: $0.text, isSelected: false) })
        (vc as? SelectionViewController)?.dataDidSelect = { [weak self] selectedData in
            guard let self else { return }
            guard let language = self.language.first(where: { $0.key == selectedData.key }) else { return }
}
        present(vc, animated: true)
    }
    
    @IBAction func didTapMenu(_ sender: Any) {
        let drawerController = DrawerMenuViewController()
        let navigation = UINavigationController(rootViewController: drawerController)
        present(navigation, animated: true)
    }
    
   @IBAction func backButtonDidTap(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func sendMessageButtonDidTap(_ sender: Any) {
    }
}
