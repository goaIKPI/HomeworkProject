//
//  StorageManager.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 28.03.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation
import UIKit

class StorageManager: ProfileDataManager {

    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func getProfile(completion: @escaping CompletionProfileLoader) {
        AppUser.getAppUser(in: coreDataStack.saveContext, completion: { (appUser) in
            if let appUser = appUser {
                let name: String = appUser.name ?? Constant.User.name
                let description: String = appUser.descriptionUser ?? ""
                let imageData = appUser.userImageData ??
                    (UIImage(named: "placeholder-user") ?? UIImage()).jpegData(compressionQuality: 1.0)
                let image = UIImage(data: imageData ?? Data()) ?? UIImage()
                let profile = Profile(name: name,
                                      description: description,
                                      userImage: image)
                DispatchQueue.main.async {
                    completion(profile)
                }
            } else {
                assert(false, "AppUser is nil")
            }
        })
    }

    func saveProfile(newProfile: IProfile, oldProfile: IProfile, completion: @escaping CompletionSaveHandler) {
        AppUser.getAppUser(in: coreDataStack.saveContext, completion: { (appUser) in
            if let appUser = appUser {
                if newProfile.name != oldProfile.name {
                    appUser.name = newProfile.name
                }
                if newProfile.description != oldProfile.description {
                    appUser.descriptionUser = newProfile.description
                }
                if newProfile.userImage != oldProfile.userImage {
                    appUser.userImageData = newProfile.userImage.jpegData(compressionQuality: 1.0)
                }
                self.coreDataStack.performSave(in: self.coreDataStack.saveContext, completion: { (error) in
                    DispatchQueue.main.async {
                        completion(error)
                    }
                })
            } else {
                DispatchQueue.main.async {
                    completion(SaveErrors.loadDataError)
                }
                return
            }
        })
    }
}
