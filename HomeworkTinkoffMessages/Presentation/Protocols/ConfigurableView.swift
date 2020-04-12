//
//  ConfigurableView.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман  on 01/03/2020.
//  Copyright © 2020 Oleg German. All rights reserved.
//

import Foundation

protocol ConfigurableView {

    associatedtype ConfigurationModel

    func configure(with model: ConfigurationModel)
}
