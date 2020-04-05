//
//  IChannelInteractor.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 23.03.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol IChannelInteractor {
    var channelDataManager: IChannelsDataManager {get set}
    func getChannel(completion: @escaping () -> Void)
    func createChannel(channel: ConversationCellModel, completion: @escaping CompletionErrorCreateChannel)
    func removeChat(conversation: Conversation)
}

class ChannelInteractor: IChannelInteractor {

    var onlineChannels: [ConversationCellModel] = []
    var historyChannels: [ConversationCellModel] = []

    var channelDataManager: IChannelsDataManager
    var channelRequester: IConversationFetchRequester
    var coreDataStack: CoreDataStack
    var fetchResultController: NSFetchedResultsController<Conversation>
    let container = NSPersistentContainer(name: "DataModel")

    init(channelDataManager: IChannelsDataManager,
         channelRequester: IConversationFetchRequester,
         coreDataStack: CoreDataStack) {
        self.channelDataManager = channelDataManager
        self.channelRequester = channelRequester
        self.coreDataStack = coreDataStack

        let request = channelRequester.fetchConversations()
        request.fetchBatchSize = 20
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { (_, error) in
            if error != nil {
            }
        }
        let mainContext = container.viewContext
        fetchResultController = NSFetchedResultsController(fetchRequest: request,
                                                           managedObjectContext: mainContext,
                                                           sectionNameKeyPath: "isOnline",
                                                           cacheName: nil)
        do {
            try fetchResultController.performFetch()
        } catch {
            assertionFailure("Error due perform fetch on fetchResultController")
        }
    }

    func getChannel(completion: @escaping () -> Void) {
        channelDataManager.getChannels(completion: { (channels) in
            self.saveChannelWithStack(channels: channels, completion: completion)
        })
    }

    func createChannel(channel: ConversationCellModel, completion: @escaping CompletionErrorCreateChannel) {
        channelDataManager.createChannel(channel: channel, completion: completion)
    }

    func removeChat(conversation: Conversation) {
        channelDataManager.deleteChannel(channel: conversation)
    }

//    func getChannelWithStack(completion: @escaping () -> Void) {
//        container.loadPersistentStores { (_, error) in
//            if error != nil {
//            }
//        }
//        container.performBackgroundTask { (context) in
//            let request = NSFetchRequest<Conversation>(entityName: "Conversation")
//            do {
//                let result = try context.fetch(request)
//                result.forEach({ (channel) in
//                    var cell = ConversationCellModel(identifier: channel.conversationId ?? "",
//                                                    name: channel.name ?? "",
//                                                    message: channel.message,
//                                                    date: channel.date ?? Date(),
//                                                    isOnline: channel.isOnline,
//                                                    hasUnreadMessages: channel.hasUnreadMessages)
//                    if Date().timeIntervalSince(channel.date ?? Date()) < 600 {
//                        cell.isOnline = true
//                        self.onlineChannels.append(cell)
//                    } else {
//                        cell.isOnline = false
//                        self.historyChannels.append(cell)
//                    }
//                })
//                DispatchQueue.main.async {
//                    do {
//                        try self.fetchResultController.performFetch()
//                    } catch {
//                        assertionFailure("Error due perform fetch on fetchResultController")
//                    }
//                    completion()
//                }
//            } catch {
//                print("Fetching data Failed")
//            }
//        }
//
//    }

    func saveChannelWithStack(channels: [ConversationCellModel], completion: @escaping () -> Void) {
        container.loadPersistentStores { (_, error) in
            if error != nil {
            }
        }
        resetAllRecords(in: "Conversation")
        container.performBackgroundTask { (context) in
            for channelItem in channels {
                let channel = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation
                channel?.conversationId = channelItem.identifier
                channel?.name = channelItem.name
                channel?.message = channelItem.message
                channel?.date = channelItem.date
                channel?.hasUnreadMessages = channelItem.hasUnreadMessages
                if Date().timeIntervalSince(channelItem.date) < 600 {
                    channel?.isOnline = true
                } else {
                    channel?.isOnline = false
                }
                do {
                    try context.save()
                } catch {
                    print("Storing data Failed")
                }
            }
            DispatchQueue.main.async {
                do {
                    try self.fetchResultController.performFetch()
                } catch {
                    assertionFailure("Error due perform fetch on fetchResultController")
                }
                completion()
            }
        }

    }

    func resetAllRecords(in entity: String) // entity = Your_Entity_Name
    {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { (_, error) in
            if error != nil {
            }
        }
        let context =  container.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("There was an error")
        }
    }
}
