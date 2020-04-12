//
//  MesssagesDataManager.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 23.03.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation
import Firebase

typealias CompletionGetMessages = ([MessageCellModel]) -> Void
typealias CompletionErrorSendMessage = (Error?) -> Void

protocol MessagesDataManagerProtocol {
    var firebaseRequester: IMessagesFirebaseRequester {get set}
    func getMessages(completion: @escaping CompletionGetMessages)
    func sendMessage(message: MessageCellModel, completion: @escaping CompletionErrorSendMessage)
}

class MessagesDataManager: MessagesDataManagerProtocol {

    var firebaseRequester: IMessagesFirebaseRequester = MessagesFirebaseRequester()

    func getMessages(completion: @escaping CompletionGetMessages) {
        firebaseRequester.getMessages(completion: completion)
    }

    func sendMessage(message: MessageCellModel, completion: @escaping CompletionErrorSendMessage) {
        firebaseRequester.sendMessage(message: message, completion: completion)
    }
}
