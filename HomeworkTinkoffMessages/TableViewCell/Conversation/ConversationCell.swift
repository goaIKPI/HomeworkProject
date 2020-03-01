//
//  ConversationCell.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман  on 01/03/2020.
//  Copyright © 2020 Oleg German. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConfigurationView {

    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var lastMessageTimeLabel: UILabel!
    
    func configure(with model: ConversationCellModel) {
        personNameLabel.text = model.name
        if model.message == nil {
            lastMessageLabel.text = "No messages yet"
            lastMessageLabel.font = UIFont(name: "Avenir-Light", size: 17.0)
        } else {
            lastMessageLabel.text = model.message
            lastMessageLabel.font = UIFont.systemFont(ofSize: 17)
        }
        lastMessageTimeLabel.text = model.stringDate
        if model.isOnline {
            backgroundColor = #colorLiteral(red: 1, green: 1, blue: 0.6601287412, alpha: 1)
        } else {
            backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        if model.hasUnreadMessages {
            lastMessageLabel.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        }
    }
    
}
