//
//  MessageCellModel.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман  on 01/03/2020.
//  Copyright © 2020 Oleg German. All rights reserved.
//

import Foundation

struct MessageCellModel {
    let text: String
    let isIncoming: Bool
    let date: Date
    let user: User
}

struct User {
    let id: String
    let name: String
}
