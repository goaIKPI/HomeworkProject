//
//  ConversationsListViewController.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман  on 01/03/2020.
//  Copyright © 2020 Oleg German. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ConversationsListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var channelInteractor = ChannelInteractor(channelDataManager: ChannelsDataManager(),
                                                      channelRequester: ConversationFetchRequester(),
                                                      coreDataStack: NestedWorkersCoreDataStack.shared)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: String(describing: ConversationCell.self),
              bundle: Bundle.main), forCellReuseIdentifier: String(describing: ConversationCell.self))
        channelInteractor.fetchResultController.delegate = self
        do {
            try channelInteractor.fetchResultController.performFetch()
        } catch {
            assertionFailure("Error due perform fetch on fetchResultController")
        }
        tableView.dataSource = self
        tableView.delegate = self
        channelInteractor.getChannel(completion: completionHandler)
        title = "Tinkoff Chat"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showConversation" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let conversationVC = segue.destination as? ConversationViewController else { return }
            conversationVC.conversation = channelInteractor.fetchResultController.object(at: indexPath)
            conversationVC.title = channelInteractor.fetchResultController.object(at: indexPath).name
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

extension ConversationsListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return channelInteractor.fetchResultController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = channelInteractor.fetchResultController.sections else { return 0 }
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let conversationCell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell",
                                                                   for: indexPath) as? ConversationCell else {
                                                                    return UITableViewCell() }
        let conversation = channelInteractor.fetchResultController.object(at: indexPath)
        conversationCell.configure(with: ConversationCellModel(identifier: conversation.conversationId ?? "",
                                                               name: conversation.name ?? "",
                                                               message: conversation.message,
                                                               date: conversation.date ?? Date(),
                                                               isOnline: conversation.isOnline,
                                                               hasUnreadMessages: conversation.hasUnreadMessages))
        return conversationCell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = channelInteractor.fetchResultController.sections else { return nil }
        return sections[section].name == "1" ? "Online" : "History"
    }
}

extension ConversationsListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showConversation", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let deleteAction = UITableViewRowAction(style: .destructive, title: "Удалить") { (_, indexPath) in
            self.channelInteractor.removeChat(conversation: self.channelInteractor.fetchResultController.object(at: indexPath))
        }

        return [deleteAction]
    }
}

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            tableView.reloadRows(at: [newIndexPath!], with: .none)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .none)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .none)
        case.move:
            tableView.deleteRows(at: [indexPath!], with: .none)
            tableView.insertRows(at: [newIndexPath!], with: .none)
        @unknown default:
            return
        }
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .none)
        case .delete:
            tableView.deleteSections(indexSet, with: .none)
        case .update:
            tableView.reloadSections(indexSet, with: .none)
        default:
            return
        }
    }
}
