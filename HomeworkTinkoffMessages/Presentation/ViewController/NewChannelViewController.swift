//
//  NewChannelViewController.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 22.03.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import UIKit
import Firebase

class NewChannelViewController: UIViewController {

    
    @IBOutlet weak var nameNewChannelField: UITextField!
    @IBOutlet weak var constraintButton: NSLayoutConstraint!
    var BUTTON_CONSTRAINT_CONSTANT: CGFloat = 32.0
    private var channelInteractor = ChannelInteractor(channelDataManager: ChannelsDataManager())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameNewChannelField.delegate = self
        registerNotifications()
    }
    

    
    @IBAction func createNewChannel(_ sender: Any) {
        //Тут важны только параметры name, message, date. Остальные берутся по дефолту.
        if nameNewChannelField.text == "" {
            showAlert(title: "Введите название канала", message: "")
            return
        }
        let channel = ConversationCellModel(identifier: "",
                                            name: nameNewChannelField.text!,
                                            message: "\(Constant.User.name) cоздал свой канал",
                                            date: Date(),
                                            isOnline: true,
                                            hasUnreadMessages: true)
        channelInteractor.createChannel(channel: channel, completion: completionHadlerCreate(error:))
           
    }
    
    
    func completionHadlerCreate(error: Error?) {
        if error == nil {
            navigationController?.popViewController(animated: true)
        } else {
            showAlert(title: "Ошибка при создании события", message: "Попробуйте еще раз")
        }
    }
    
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.constraintButton.constant == BUTTON_CONSTRAINT_CONSTANT {
                self.constraintButton.constant += keyboardSize.height - BUTTON_CONSTRAINT_CONSTANT
            }
        }
    }
       
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.constraintButton.constant != BUTTON_CONSTRAINT_CONSTANT {
            self.constraintButton.constant = BUTTON_CONSTRAINT_CONSTANT
        }
    }
       
    
}

extension NewChannelViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}
