//
//  IProfile.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 15.03.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation
import UIKit

protocol IProfile {
    var name: String { get set }
    var description: String { get set }
    var userImage: UIImage { get set }
}

struct Profile: IProfile {
    var name: String = "Имя"
    var description: String = "Описание"
    var userImage: UIImage = UIImage(named: "placeholder-user")!
}

