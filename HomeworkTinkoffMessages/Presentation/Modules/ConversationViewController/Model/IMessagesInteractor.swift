//
//  IMessagesInteractor.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 23.03.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation
import CoreData

protocol IMessagesInteractor {
    var messageDataManager: MessagesDataManagerProtocol {get set}
    var messages: [MessageCellModel] {get set}
    func getMessages(completion: @escaping () -> Void)
    func sendMessage(message: MessageCellModel, completion: @escaping CompletionErrorSendMessage)
}

class MessagesInteractor: IMessagesInteractor {

    var messages: [MessageCellModel] = []
    let container = NSPersistentContainer(name: "DataModel")

    var messageDataManager: MessagesDataManagerProtocol

    init(messageDataManager: MessagesDataManagerProtocol) {
        self.messageDataManager = messageDataManager
    }

    func getMessages(completion: @escaping () -> Void) {
        messageDataManager.getMessages { (messages) in
            DispatchQueue.main.async { [weak self] in
                self?.messages = messages
                completion()
            }
            //self.saveMessageWithStack(messages: messages)
        }
    }

    func sendMessage(message: MessageCellModel, completion: @escaping CompletionErrorSendMessage) {
        messageDataManager.sendMessage(message: message) { (error) in
            completion(error)
        }
    }

    func saveMessageWithStack(messages: [MessageCellModel]) {
        container.loadPersistentStores { (_, error) in
            if error != nil {
            }
        }
        resetAllRecords(in: "Message")
        container.performBackgroundTask { (context) in
            for messageItem in messages {
                let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message
                message?.conversationId = ""
                message?.userName = messageItem.user.name
                message?.date = messageItem.date
                message?.isIncoming = messageItem.isIncoming
                message?.text = messageItem.text
                do {
                    try context.save()
                } catch {
                    print("Storing data Failed")
                }
            }
            //self.getMessagesWithStack(completion: {})
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
