//
//  ConversationsListViewController.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман  on 01/03/2020.
//  Copyright © 2020 Oleg German. All rights reserved.
//

import UIKit
import Firebase

class ConversationsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let onlineUserConversations: [ConversationCellModel] = []
    let historyConversations: [ConversationCellModel] = []
    
    private var channelInteractor = ChannelInteractor(channelDataManager: ChannelsDataManager())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: String(describing: ConversationCell.self),
              bundle: Bundle.main), forCellReuseIdentifier: String(describing: ConversationCell.self))
        
        tableView.dataSource = self
        tableView.delegate = self
        channelInteractor.getChannel(completion: completionHandler)
        title = "Tinkoff Chat"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showConversation" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let conversationVC = segue.destination as! ConversationViewController
            if indexPath.section == 0 {
                conversationVC.channel = channelInteractor.onlineChannels[indexPath.row]
                conversationVC.title = channelInteractor.onlineChannels[indexPath.row].name
            } else {
                conversationVC.channel = channelInteractor.historyChannels[indexPath.row]
                conversationVC.title = channelInteractor.historyChannels[indexPath.row].name
            }
        }
    }
    
    func completionHandler() {
        tableView.reloadData()
    }
    
    @IBAction func newChannel(_ sender: Any) {
        let controller = NewChannelViewController(nibName: "NewChannelViewController", bundle: nil)
        controller.title = "Создание канала"
        navigationController?.pushViewController(controller, animated: true)
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
        switch section {
        case 0:
            return channelInteractor.onlineChannels.count
        case 1:
            return channelInteractor.historyChannels.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        case 1:
             return "History"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ConversationCell.self)) as? ConversationCell else { return UITableViewCell() }
        if indexPath.section == 0 {
            cell.configure(with: channelInteractor.onlineChannels[indexPath.row])
        } else {
            cell.configure(with: channelInteractor.historyChannels[indexPath.row])
        }
        return cell
    }
}
