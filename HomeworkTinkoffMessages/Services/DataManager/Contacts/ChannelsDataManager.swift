//
//  ChannelsDataManager.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 23.03.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

typealias CompletionGetChannels = ([ConversationCellModel]) -> Void
typealias CompletionErrorCreateChannel = (Error?) -> Void

protocol IChannelsDataManager {
    func getChannels(completion: @escaping CompletionGetChannels)
    func createChannel(channel: ConversationCellModel, completion: @escaping CompletionErrorCreateChannel)
    func deleteChannel(channel: Conversation)
}

class ChannelsDataManager: IChannelsDataManager {

    private lazy var dataBase = Firestore.firestore()
    var channel: ConversationCellModel?
    var channels: [ConversationCellModel] = []

    private lazy var referenceChannel: CollectionReference = {
        return dataBase.collection("channels")
    }()

    func createChannel(channel: ConversationCellModel, completion: @escaping CompletionErrorCreateChannel) {
        let document = referenceChannel.addDocument(data: channel.toDict, completion: { error in
            completion(error)
        })

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
        referenceChannel.addSnapshotListener { [weak self] snapshot, _ in
            guard let snapshot = snapshot else { return }
            self?.channels = []
            for snapshotItem in snapshot.documents {
                let timestamp = snapshotItem.data()["lastActivity"] as? Timestamp
                let date = (timestamp ?? Timestamp(seconds: 0, nanoseconds: 0)).dateValue()
                let dataModel = ConversationCellModel(identifier: snapshotItem.documentID,
                                                      name: snapshotItem.data()["name"] as? String ?? "",
                                                      message: snapshotItem.data()["lastMessage"] as? String ?? "",
                                                      date: date,
                                                      isOnline: true,
                                                      hasUnreadMessages: false)
                self?.channels.append(dataModel)
            }
            self?.channels.sort(by: {$0.date > $1.date})
            completion(self?.channels ?? [])
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
