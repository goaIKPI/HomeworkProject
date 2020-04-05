//
//  Conversation.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 05.04.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import CoreData

extension Conversation {
    static func insertConversationWith(conversationId: String,
                                       in context: NSManagedObjectContext) -> Conversation {
        guard let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation",
                                                                     into: context)
            as? Conversation else {
                fatalError("Can't insert Conversation")
        }
        conversation.conversationId = conversationId
        return conversation
    }

    static func findConversationWith(conversationId: String,
                                     in context: NSManagedObjectContext,
                                     by conversationRequester: IConversationFetchRequester) -> Conversation? {
        let fetchConversationWithId = conversationRequester.fetchConversationWith(conversationId: conversationId)
        do {
            let conversationsWithId = try context.fetch(fetchConversationWithId)
            assert(conversationsWithId.count < 2, "Conversations with id: \(conversationId) more than 1")
            if !conversationsWithId.isEmpty {
                let conversation = conversationsWithId.first!
                return conversation
            } else {
                return nil
            }
        } catch {
            assertionFailure("Can't get conversations by a fetch. May be there is an incorrect fetch")
            return nil
        }
    }

    static func findOrInsertConversationWith(conversationId: String,
                                             in context: NSManagedObjectContext,
                                             by conversationRequester: IConversationFetchRequester) -> Conversation {
        guard let conversation = Conversation.findConversationWith(conversationId: conversationId,
                                                                   in: context,
                                                                   by: conversationRequester) else {
            return Conversation.insertConversationWith(conversationId: conversationId, in: context)
        }
        return conversation
    }

    static func findOnlineConversations(in context: NSManagedObjectContext,
                                        by conversationRequester: IConversationFetchRequester) -> [Conversation]? {
        let fetchRequest = conversationRequester.fetchOnlineConversations()
        do {
            let conversations = try context.fetch(fetchRequest)
            return conversations
        } catch {
            assertionFailure("Can't get conversations by a fetch. May be there is an incorrect fetch")
            return nil
        }
    }
}
