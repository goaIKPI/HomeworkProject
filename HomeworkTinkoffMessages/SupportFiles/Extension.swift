//
//  ExtensionViewController.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 15.03.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//
import UIKit
import Foundation
import Firebase

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)

        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension MessageCellModel {
    var toDict: [String: Any] {
        return ["content": text,
                "created": Timestamp(date: date),
                "senderID": user.identifier,
                "senderName": user.name]
    }
}

extension ConversationCellModel {
    var toDict: [String: Any] {
        return ["name": name,
                "lastMessage": message ?? "",
                "lastActivity": Date()]
    }
}
