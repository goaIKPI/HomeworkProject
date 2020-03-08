//
//  ConversationsListViewController.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман  on 01/03/2020.
//  Copyright © 2020 Oleg German. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let onlineUserConversations = [ConversationCellModel(name: "Oleg",
                                                         message: "Hello",
                                                         date: Date(),
                                                         isOnline: true,
                                                         hasUnreadMessages: true),
                                   ConversationCellModel(name: "Vasya",
                                                         message: nil,
                                                         date: Date(),
                                                         isOnline: true,
                                                         hasUnreadMessages: false),
                                   ConversationCellModel(name: "Masya",
                                                         message: "push to git",
                                                         date: Date(),
                                                         isOnline: false,
                                                         hasUnreadMessages: false),
                                   ConversationCellModel(name: "Georgy",
                                                         message: "Study!",
                                                         date: Date(),
                                                         isOnline: true,
                                                         hasUnreadMessages: false),
                                   ConversationCellModel(name: "Evgeni",
                                                         message: "get your message",
                                                         date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                                                         isOnline: true,
                                                         hasUnreadMessages: true)]
    let historyConversations = [ConversationCellModel(name: "Jack",
                                                      message: "Oklahoma remember you",
                                                      date: Date(),
                                                      isOnline: true,
                                                      hasUnreadMessages: false),
                                ConversationCellModel(name: "Daniels",
                                                      message: "Me too",
                                                      date: Date(),
                                                      isOnline: false,
                                                      hasUnreadMessages: true),
                                ConversationCellModel(name: "Андрей",
                                                      message: "Русские символы работают?",
                                                      date: Date(),
                                                      isOnline: true,
                                                      hasUnreadMessages: false),
                                ConversationCellModel(name: "Начальник",
                                                      message: "когда будет готов проект?",
                                                      date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                                                      isOnline: false,
                                                      hasUnreadMessages: true)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: String(describing: ConversationCell.self),
              bundle: Bundle.main), forCellReuseIdentifier: String(describing: ConversationCell.self))
        
        tableView.dataSource = self
        tableView.delegate = self

        
        title = "Tinkoff Chat"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showConversation" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let conversationVC = segue.destination as! ConversationViewController
            if indexPath.section == 0 {
                conversationVC.title = onlineUserConversations[indexPath.row].name
            } else {
                conversationVC.title = historyConversations[indexPath.row].name
            }
        }
    }
}

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showConversation", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return onlineUserConversations.count
        }
        return historyConversations.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Online"
        }
        return "History"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ConversationCell.self)) as? ConversationCell else { return UITableViewCell() }
        if indexPath.section == 0 {
            cell.configure(with: onlineUserConversations[indexPath.row])
        } else {
            cell.configure(with: historyConversations[indexPath.row])
        }
        return cell
    }
}
