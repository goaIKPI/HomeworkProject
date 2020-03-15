//
//  ProfileDataManager.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 15.03.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation

typealias CompletionSaveHandler = (Error?) -> ()
typealias CompletionProfileLoader = (IProfile) -> Void

protocol ProfileDataManager {
    func getProfile(completion: @escaping CompletionProfileLoader)
    func saveProfile(newProfile: IProfile, oldProfile: IProfile, completion: @escaping CompletionSaveHandler)
}

enum SaveErrors: Error {
    case convertDataError
    case loadDataError
}
