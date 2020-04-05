//
//  MessageFetchRequester.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 05.04.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import CoreData

protocol IMessageFetchRequester {
    func fetchMessagesFrom(conversationId: String) -> NSFetchRequest<Message>
}

class MessageFetchRequester: IMessageFetchRequester {

    func fetchMessagesFrom(conversationId: String) -> NSFetchRequest<Message> {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "conversationId == %@", conversationId)
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
        return request
    }
}
