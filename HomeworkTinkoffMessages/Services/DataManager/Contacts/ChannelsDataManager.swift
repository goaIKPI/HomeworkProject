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

    var firebaseRequester: IConversationFirebaseRequester = ConversationFirebaseRequester()

    func createChannel(channel: ConversationCellModel, completion: @escaping CompletionErrorCreateChannel) {
        firebaseRequester.createChannel(channel: channel, completion: completion)
    }

    func getChannels(completion: @escaping CompletionGetChannels) {
        firebaseRequester.getChannels(completion: completion)
    }

    func deleteChannel(channel: Conversation) {
        firebaseRequester.deleteChannel(channel: channel)
    }

}
