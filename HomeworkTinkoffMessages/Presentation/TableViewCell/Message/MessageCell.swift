//
//  MessageCell.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман  on 01/03/2020.
//  Copyright © 2020 Oleg German. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, ConfigurableView {
    
    @IBOutlet var rightConstraint: NSLayoutConstraint!
    @IBOutlet var leftConstaint: NSLayoutConstraint!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var dateMessageLabel: UILabel!
    
    
    
    func configure(with model: MessageCellModel) {
        setCornerRadius()
        messageLabel.text = model.text
        rightConstraint.isActive = !model.isIncoming
        leftConstaint.isActive = model.isIncoming
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateMessageLabel.text = dateFormatter.string(from: model.date)
        senderNameLabel.text = model.user.name
        
    }
    
    func setCornerRadius() {
        background.layer.cornerRadius = 12
    }
}
