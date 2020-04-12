//
//  ConversationFirebaseRequester.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 13.04.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation
import Firebase

protocol IConversationFirebaseRequester {
    func getChannels(completion: @escaping CompletionGetChannels)
    func createChannel(channel: ConversationCellModel, completion: @escaping CompletionErrorCreateChannel)
    func deleteChannel(channel: Conversation)
}

class ConversationFirebaseRequester: IConversationFirebaseRequester {
    private lazy var dataBase = Firestore.firestore()

    private lazy var referenceChannel: CollectionReference = {
        return dataBase.collection("channels")
    }()

    func createChannel(channel: ConversationCellModel, completion: @escaping CompletionErrorCreateChannel) {
        let document = referenceChannel.addDocument(data: channel.toDict, completion: { error in
            completion(error)
        })

        addCreateMessage(document: document)
    }

    func addCreateMessage(document: DocumentReference) {
        //Небольшой костыль за 3 минуты до сдачи
        let text = "\(Constant.User.name) создал канал"
        let dataModel =  MessageCellModel(text: text,
                                          isIncoming: true,
                                          date: Date(),
                                          user: UserModel(identifier: String(Constant.User.identifier),
                                                          name: Constant.User.name)).toDict
        document.collection("messages").addDocument(data: dataModel)
    }

    func getChannels(completion: @escaping CompletionGetChannels) {
        referenceChannel.addSnapshotListener { snapshot, _ in
            guard let snapshot = snapshot else { return }
            var channels: [ConversationCellModel] = []
            for snapshotItem in snapshot.documents {
                let timestamp = snapshotItem.data()["lastActivity"] as? Timestamp
                let date = (timestamp ?? Timestamp(seconds: 0, nanoseconds: 0)).dateValue()
                let dataModel = ConversationCellModel(identifier: snapshotItem.documentID,
                                                      name: snapshotItem.data()["name"] as? String ?? "",
                                                      message: snapshotItem.data()["lastMessage"] as? String ?? "",
                                                      date: date,
                                                      isOnline: true,
                                                      hasUnreadMessages: false)
                channels.append(dataModel)
            }
            channels.sort(by: {$0.date > $1.date})
            completion(channels)
        }
    }

    func deleteChannel(channel: Conversation) {
        _ = self.referenceChannel.document(channel.conversationId ?? "").delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }

}
