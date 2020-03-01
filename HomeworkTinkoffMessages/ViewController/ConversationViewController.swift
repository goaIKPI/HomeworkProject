//
//  ConversationViewController.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман  on 01/03/2020.
//  Copyright © 2020 Oleg German. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: String(describing: MessageCell.self),
                                     bundle: Bundle.main),
                               forCellReuseIdentifier: String(describing: MessageCell.self))
        }
    }
    
    let messages = [MessageCellModel(text: "Hello", isIncoming: true), MessageCellModel(text: "Hi!", isIncoming: false), MessageCellModel(text: "How are you?", isIncoming: true), MessageCellModel(text: "Fine!", isIncoming: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ConversationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: MessageCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageCell else { return UITableViewCell() }
        cell.configure(with: messages[indexPath.row])
        return cell
    }  
}
