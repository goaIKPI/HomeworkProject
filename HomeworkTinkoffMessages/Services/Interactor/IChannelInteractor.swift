//
//  IChannelInteractor.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 23.03.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation

protocol IChannelInteractor {
    var channelDataManager: ChannelsDataManagerProtocol {get set}
    func getChannel(completion: @escaping () -> Void)
    func createChannel(channel: ConversationCellModel, completion: @escaping CompletionErrorCreateChannel)
}

class ChannelInteractor: IChannelInteractor {

    var onlineChannels: [ConversationCellModel] = []
    var historyChannels: [ConversationCellModel] = []

    var channelDataManager: ChannelsDataManagerProtocol

    init(channelDataManager: ChannelsDataManagerProtocol) {
        self.channelDataManager = channelDataManager
    }

    func getChannel(completion: @escaping () -> Void) {
        channelDataManager.getChannels(completion: { (channels) in
            DispatchQueue.main.async { [weak self] in
                self?.onlineChannels = []
                self?.historyChannels = []
                for channel in channels {
                    print(channel.date.timeIntervalSince(Date()))
                    if Date().timeIntervalSince(channel.date) < 600 {
                        self?.onlineChannels.append(channel)
                    } else {
                        self?.historyChannels.append(channel)
                    }
                }
                completion()
            }
        })
    }

    func createChannel(channel: ConversationCellModel, completion: @escaping CompletionErrorCreateChannel) {
        channelDataManager.createChannel(channel: channel, completion: completion)
    }

}
