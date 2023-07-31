//
//  AskQuestionViewController.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 26.06.2023.
//

import UIKit

class AskQuestionViewController: BaseViewController, UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    @IBOutlet weak var askQuestionLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textFieldMessage: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundTypeView: UIView!
    @IBOutlet weak var textViewWriteMessage: UITextView!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    var overlayView: OverlayView!
    
    private var type = [TypeModel]()
    private var language = [LanguageModel]()
    
    private var tableViewMessages: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: CellManager.getCell(by: "RightMessagesCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "RightMessagesCell"))
        table.register(UINib(nibName: CellManager.getCell(by: "LeftMessagesCell") , bundle: nil), forCellReuseIdentifier: CellManager.getCell(by: "LeftMessagesCell"))
        table.backgroundColor = nil
        table.separatorColor = .clear
        return table
    }()
    
    var messagesModel = [ChatModel(textMessaging: "Hello", id: 1, time: "17:57", isMe: true), ChatModel(textMessaging: "Hello there", id: 2, time: "17:58", isMe: false), ChatModel(textMessaging: "How are you?", id: 1, time: "17:58", isMe: true), ChatModel(textMessaging: "Good!", id: 2, time: "18:00", isMe: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            sendMessageButton.layer.cornerRadius = 12
            textViewWriteMessage.layer.cornerRadius = 12
            backgroundTypeView.layer.cornerRadius = 12
            
        default: sendMessageButton.layer.cornerRadius = 24
                 textViewWriteMessage.layer.cornerRadius = 24
                 backgroundTypeView.layer.cornerRadius = 24
        }
       
        sendMessageButton.layer.masksToBounds = true
        textViewWriteMessage.layer.masksToBounds = true
        backgroundTypeView.layer.masksToBounds = true
        textViewWriteMessage.delegate = self
        scrollView.delegate = self
        setupOverlayView()
        tableViewMessages.dataSource = self
        tableViewMessages.delegate = self
        textFieldMessage.layer.cornerRadius = 15
        textFieldMessage.layer.masksToBounds = true
        textFieldMessage.text = "Write a message"
        textFieldMessage.textColor = UIColor(red: 210/255, green: 212/255, blue: 214/255, alpha: 1)
        
        askQuestionLabel.text = "askQestion".localized
        backButton.setTitle("back".localized, for: .normal)
        sendButton.setTitle("".localized, for: .normal)
        sendMessageButton.setTitle("sendMessage".localized, for: .normal)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewMessages.frame = CGRect(x: 50, y: view.safeAreaInsets.top, width: view.bounds.size.width, height: view.bounds.size.height)
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
        let vc = storyboard.instantiateViewController(withIdentifier: CellManager.getCell(by: "SelectionViewController"))
        (vc as? SelectionViewController)?.allItems = language.map({ .init(key: $0.key, name: $0.text, isSelected: false) })
        (vc as? SelectionViewController)?.dataDidSelect = { [weak self] selectedData in
            guard let self else { return }
            guard let language = self.language.first(where: { $0.key == selectedData.key }) else { return }
        }
        present(vc, animated: true)
    }
    
    @IBAction func didTapMenu(_ sender: Any) {
        let drawerController = DrawerMenuViewController.shared
        present(drawerController, animated: true)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        DrawerMenuViewController.shared.back()
    }
    
    @IBAction func sendMessageButtonDidTap(_ sender: Any) {
    }
}

extension AskQuestionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messagesModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = messagesModel[indexPath.row]
        if model.isMe {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: "RightMessagesCell"), for: indexPath)
            (cell as? RightMessagesCell)?.configure(text: model.textMessaging, time: model.time)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellManager.getCell(by: "LefttMessagesCell"), for: indexPath)
            (cell as? LeftMessagesCell)?.configure(text: model.textMessaging, time: model.time)
            return cell
        }
    }
}
