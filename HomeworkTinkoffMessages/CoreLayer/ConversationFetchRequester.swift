//
//  ConversationFetchRequester.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 05.04.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import CoreData

protocol IConversationFetchRequester {
    func fetchConversations() -> NSFetchRequest<Conversation>
    func fetchOnlineConversations() -> NSFetchRequest<Conversation>
    func fetchConversationWith(conversationId: String) -> NSFetchRequest<Conversation>
    func fetchNonEmptyOnlineConversations() -> NSFetchRequest<Conversation>
}

class ConversationFetchRequester: IConversationFetchRequester {

    func fetchConversations() -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let onlineSortDescriptor = NSSortDescriptor(key: "isOnline", ascending: false)
        request.sortDescriptors = [onlineSortDescriptor, dateSortDescriptor]
        return request
    }

    func fetchOnlineConversations() -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "isOnline == YES")
        return request
    }

    func fetchConversationWith(conversationId: String) -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "conversationId == %@", conversationId)
        return request
    }

    func fetchNonEmptyOnlineConversations() -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "messageHistory.@count > 0 AND user.isOnline == 1")
        return request
    }
}
