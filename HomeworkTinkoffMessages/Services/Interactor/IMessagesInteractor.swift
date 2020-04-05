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

//    func getMessagesWithStack(completion: @escaping ()->()) {
//        container.loadPersistentStores { (_, error) in
//            if error != nil {
//            }
//        }
//        container.performBackgroundTask { (context) in
//            let request = NSFetchRequest<Message>(entityName: "Message")
//            let predicate = NSPredicate(format: "conversationId == %@", "")
//            request.predicate = predicate
//            do {
//                self.messages = []
//                let result = try context.fetch(request)
//                result.forEach({ (message) in
//                    self.messages.append(MessageCellModel(text: message.text ?? "",
//                                                          isIncoming: message.isIncoming,
//                                                          date: message.date ?? Date(),
//                                                          user: UserModel(identifier: message.conversationId ?? "",
//                                                                          name: message.conversation?.name ?? "")))
//                })
//                DispatchQueue.main.async {
//                    completion()
//                }
//            } catch {
//                print("Fetching data Failed")
//            }
//        }
//
//    }

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
