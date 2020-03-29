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

typealias CompletionGetChannels = ([ConversationCellModel]) -> ()
typealias CompletionErrorCreateChannel = (Error?) -> (Void)

protocol ChannelsDataManagerProtocol {
    func getChannels(completion: @escaping CompletionGetChannels)
    func createChannel(channel: ConversationCellModel, completion: @escaping CompletionErrorCreateChannel)
}

class ChannelsDataManager: ChannelsDataManagerProtocol {
    
    private lazy var db = Firestore.firestore()
    var channel: ConversationCellModel?
    var channels: [ConversationCellModel] = []
    
    private lazy var referenceChannel: CollectionReference = {
        return db.collection("channels")
    }()

    
    func createChannel(channel: ConversationCellModel, completion: @escaping CompletionErrorCreateChannel) {
        let document = referenceChannel.addDocument(data: channel.toDict, completion: { error in
            completion(error)
        })
        
        //Небольшой костыль за 3 минуты до сдачи
        document.collection("messages").addDocument(data: MessageCellModel(text: channel.message ?? "",
                                                                           isIncoming: true,
                                                                           date: Date(),
                                                                           user: User(id: String(Constant.User.id),
                                                                            name: Constant.User.name)).toDict)
    
    }
    
    func getChannels(completion: @escaping CompletionGetChannels) {
        referenceChannel.addSnapshotListener { [weak self] snapshot, error in
            self?.channels = []
            for snapshotItem in snapshot!.documents {
                print(snapshotItem.data())
                self?.channels.append(ConversationCellModel(identifier: snapshotItem.documentID,
                                                            name: snapshotItem.data()["name"] as? String ?? "",
                                                            message: snapshotItem.data()["lastMessage"] as? String ?? "",
                                                            date: (snapshotItem.data()["lastActivity"] as? Timestamp ?? Timestamp(seconds: 0, nanoseconds: 0)).dateValue(),
                                                            isOnline: true,
                                                            hasUnreadMessages: false))
            }
            self?.channels.sort(by: {$0.date > $1.date})
            completion(self?.channels ?? [])
        }
    }
    
    
}
