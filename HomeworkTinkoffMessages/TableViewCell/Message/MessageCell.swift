//
//  MessageCell.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман  on 01/03/2020.
//  Copyright © 2020 Oleg German. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, ConfigurationView {
    
    @IBOutlet var rightConstraint: NSLayoutConstraint!
    @IBOutlet var leftConstaint: NSLayoutConstraint!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    func configure(with model: MessageCellModel) {
        setCornerRadius()
        messageLabel.text = model.text
        rightConstraint.isActive = !model.isIncoming
        leftConstaint.isActive = model.isIncoming
    }
    
    func setCornerRadius() {
        background.layer.cornerRadius = 12
    }
}
