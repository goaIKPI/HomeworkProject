//
//  IMessagesInteractor.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 23.03.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation

protocol IMessagesInteractor {
    var messageDataManager: MessagesDataManagerProtocol {get set}
    var messages: [MessageCellModel] {get set}
    func getMessages(completion: @escaping () -> Void)
    func sendMessage(message: MessageCellModel, completion: @escaping CompletionErrorSendMessage)
}

class MessagesInteractor: IMessagesInteractor {

    var messages: [MessageCellModel] = []

    var messageDataManager: MessagesDataManagerProtocol

    init(messageDataManager: MessagesDataManagerProtocol) {
        self.messageDataManager = messageDataManager
    }

    func getMessages(completion: @escaping () -> Void) {
        messageDataManager.getMessages { (messages) in
            DispatchQueue.main.async { [weak self] in
                self?.messages = messages
                completion()
            }
        }
    }

    func sendMessage(message: MessageCellModel, completion: @escaping CompletionErrorSendMessage) {
        messageDataManager.sendMessage(message: message) { (error) in
            completion(error)
        }
    }

}
