//
//  MesssagesDataManager.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 23.03.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation
import Firebase

typealias CompletionGetMessages = ([MessageCellModel]) -> ()
typealias CompletionErrorSendMessage = (Error?) -> ()

protocol MessagesDataManagerProtocol {
    var channel: ConversationCellModel? {get set}
    func getMessages(completion: @escaping CompletionGetMessages)
    func sendMessage(message: MessageCellModel, completion: @escaping CompletionErrorSendMessage)
}

class MessagesDataManager: MessagesDataManagerProtocol {
    
    private lazy var db = Firestore.firestore()
    var channel: ConversationCellModel? = nil
    var messages: [MessageCellModel] = []
    private lazy var referenceMessages: CollectionReference = {
    guard let channelIdentifier = channel?.identifier else { fatalError() }
        return db.collection("channels").document(channelIdentifier).collection("messages")
    }()

    
    
    
    func getMessages(completion: @escaping CompletionGetMessages) {
        referenceMessages.addSnapshotListener { [weak self] snapshot, error in
            guard let snapshot = snapshot else { return }
            self?.messages = []
            for snapshotItem in snapshot.documents {
                self?.messages.append(MessageCellModel(text: snapshotItem["content"] as? String ?? "",
                                                       isIncoming: (self?.isIncoming(id: snapshotItem["senderID"] as? String ?? ""))!,
                                                       date: (snapshotItem["created"] as? Timestamp ?? Timestamp()).dateValue(),
                                                       user: User(id: snapshotItem["senderID"] as? String ?? "",
                                                                  name: snapshotItem["senderName"] as? String ?? "")))
            }
            self?.messages.sort(by: {$0.date<$1.date})
            self?.messages.reverse()
            completion(self?.messages ?? [])
        }
    }
    
    func isIncoming(id: String) -> Bool {
        return Int(id) == Constant.User.id ? false : true
    }
    
    func sendMessage(message: MessageCellModel, completion: @escaping CompletionErrorSendMessage) {
        referenceMessages.addDocument(data: message.toDict, completion: { error in
            completion(error)
        })
    }
}
