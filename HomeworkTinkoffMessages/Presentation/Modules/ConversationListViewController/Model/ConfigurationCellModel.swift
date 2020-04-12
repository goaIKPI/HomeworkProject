//
//  ConfigurationCellModel.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман  on 01/03/2020.
//  Copyright © 2020 Oleg German. All rights reserved.
//

import Foundation
import CoreData

struct ConversationCellModel {
    var identifier: String
    var name: String
    var message: String?
    var date: Date
    var isOnline: Bool
    var hasUnreadMessages: Bool

    var stringDate: String {
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "HH:mm"
        } else {
            dateFormatter.dateFormat = "dd MMM"
        }
        return dateFormatter.string(from: date)
    }

}
