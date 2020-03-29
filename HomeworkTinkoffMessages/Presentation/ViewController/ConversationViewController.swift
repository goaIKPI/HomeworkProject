//
//  ConversationViewController.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман  on 01/03/2020.
//  Copyright © 2020 Oleg German. All rights reserved.
//

import UIKit
import Firebase

class ConversationViewController: UIViewController {

    private var messagesInteractor = MessagesInteractor(messageDataManager: MessagesDataManager())

    @IBOutlet weak var constraintViewToBottom: NSLayoutConstraint!

    @IBOutlet weak var newMessageField: UITextField!

    var channel: ConversationCellModel?

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: String(describing: MessageCell.self),
                                     bundle: Bundle.main),
                               forCellReuseIdentifier: String(describing: MessageCell.self))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        registerNotifications()
        messagesInteractor.messageDataManager.channel = channel
        messagesInteractor.getMessages(completion: completionGetHandler)
    }

    @IBAction func sendMessage(_ sender: UIButton) {
        if newMessageField.text == "" {
            newMessageField.endEditing(true)
            showAlert(title: "Введите сообщение", message: "")
            return
        }
        let text: String! = newMessageField.text != nil ? newMessageField.text! : ""
        let message = MessageCellModel(text: text,
                                       isIncoming: true,
                                       date: Date(),
                                       user: User(identifier: String(Constant.User.identifier),
                                                  name: Constant.User.name))
        newMessageField.endEditing(true)
        newMessageField.text = ""
        messagesInteractor.sendMessage(message: message, completion: completionSendMessage(error:))
    }

    private func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] else { return }
        if let keyboardSize = (userInfo as? NSValue)?.cgRectValue {
            if self.constraintViewToBottom.constant == 0 {
                self.constraintViewToBottom.constant -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.constraintViewToBottom.constant != 0 {
            self.constraintViewToBottom.constant = 0
        }
    }

    func completionGetHandler() {
        tableView.reloadData()
    }

    func completionSendMessage(error: Error?) {
        if error == nil {
        } else {
            showAlert(title: "Произошла ошибка", message: "")
        }
    }
}

extension ConversationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesInteractor.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: MessageCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageCell else {
            return UITableViewCell()
        }
        cell.configure(with: messagesInteractor.messages[indexPath.row])
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
}
