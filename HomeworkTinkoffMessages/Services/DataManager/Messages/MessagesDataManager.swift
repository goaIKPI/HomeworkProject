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
    var channel: Conversation? {get set}
    func getMessages(completion: @escaping CompletionGetMessages)
    func sendMessage(message: MessageCellModel, completion: @escaping CompletionErrorSendMessage)
}

class MessagesDataManager: MessagesDataManagerProtocol {

    private lazy var dataBase = Firestore.firestore()
    var channel: Conversation?
    var messages: [MessageCellModel] = []
    private lazy var referenceMessages: CollectionReference = {
        guard let channelIdentifier = channel?.conversationId else { fatalError() }
        return dataBase.collection("channels").document(channelIdentifier).collection("messages")
    }()

    func getMessages(completion: @escaping CompletionGetMessages) {
        referenceMessages.addSnapshotListener { [weak self] snapshot, _ in
            guard let snapshot = snapshot else { return }
            self?.messages = []
            for snapshotItem in snapshot.documents {
                guard let self = self else { return }
                let inComing = self.isIncoming(identifier: snapshotItem["senderID"] as? String ?? "")
                let date = (snapshotItem["created"] as? Timestamp ?? Timestamp()).dateValue()
                let dataModel = MessageCellModel(text: snapshotItem["content"] as? String ?? "",
                                                 isIncoming: inComing,
                                                 date: date,
                                                 user: UserModel(identifier: snapshotItem["senderID"] as? String ?? "",
                                                            name: snapshotItem["senderName"] as? String ?? ""))
                self.messages.append(dataModel)
            }
            self?.messages.sort(by: {$0.date<$1.date})
            self?.messages.reverse()
            completion(self?.messages ?? [])
        }
    }

    func isIncoming(identifier: String) -> Bool {
        return Int(identifier) == Constant.User.identifier ? false : true
    }

    func sendMessage(message: MessageCellModel, completion: @escaping CompletionErrorSendMessage) {
        referenceMessages.addDocument(data: message.toDict, completion: { error in
            completion(error)
        })
    }
}
