//
//  MessagesFirebaseRequester.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 13.04.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation
import Firebase

protocol IMessagesFirebaseRequester {
    var channel: Conversation? {get set}
    func getMessages(completion: @escaping CompletionGetMessages)
    func sendMessage(message: MessageCellModel, completion: @escaping CompletionErrorSendMessage)
}

class MessagesFirebaseRequester: IMessagesFirebaseRequester {
     private lazy var dataBase = Firestore.firestore()
     var channel: Conversation?

     private lazy var referenceMessages: CollectionReference? = {
        guard let channelIdentifier = channel?.conversationId else { print("error channel identifier"); return nil }
         return dataBase.collection("channels").document(channelIdentifier).collection("messages")
     }()

     func getMessages(completion: @escaping CompletionGetMessages) {
         referenceMessages?.addSnapshotListener { [weak self] snapshot, _ in
             guard let snapshot = snapshot else { return }
             var messages: [MessageCellModel] = []
             for snapshotItem in snapshot.documents {
                 guard let self = self else { return }
                 let inComing = self.isIncoming(identifier: snapshotItem["senderID"] as? String ?? "")
                 let date = (snapshotItem["created"] as? Timestamp ?? Timestamp()).dateValue()
                 let dataModel = MessageCellModel(text: snapshotItem["content"] as? String ?? "",
                                                  isIncoming: inComing,
                                                  date: date,
                                                  user: UserModel(identifier: snapshotItem["senderID"] as? String ?? "",
                                                             name: snapshotItem["senderName"] as? String ?? ""))
                 messages.append(dataModel)
             }
             messages.sort(by: {$0.date<$1.date})
             messages.reverse()
             completion(messages)
         }
     }

     func isIncoming(identifier: String) -> Bool {
         return Int(identifier) == Constant.User.identifier ? false : true
     }

     func sendMessage(message: MessageCellModel, completion: @escaping CompletionErrorSendMessage) {
         referenceMessages?.addDocument(data: message.toDict, completion: { error in
             completion(error)
         })
     }
}
