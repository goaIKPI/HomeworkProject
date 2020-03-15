//
//  IProfileInteractor.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 15.03.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation
import UIKit

protocol IProfileInteractor {
    var profile: IProfile! { get set }
    var profileDataManager: ProfileDataManager { get set }
    func loadProfile(completion: @escaping ()->Void)
    func saveProfile(name: String, description: String, image: UIImage, completion: @escaping CompletionSaveHandler)
    var name: String { get }
    var description: String { get }
    var imageData: UIImage { get }
}

class ProfileInteractor: IProfileInteractor {
    
    var profileDataManager: ProfileDataManager
    
    var description: String {
        if profile.description == "" {
            return "Описание"
        } else {
            return profile.description
        }
    }

    var name: String {
        if profile.name == "" {
            return "Имя"
        } else {
            return profile.name
        }
    }

    var imageData: UIImage {
        if profile.userImage == UIImage() {
            return UIImage(named: "user")!
        } else {
            return profile.userImage
        }
    }

    var profile: IProfile! = Profile()


    init(profileDataManager: ProfileDataManager) {
        self.profileDataManager = profileDataManager
    }

    func loadProfile(completion: @escaping () -> Void) {
        profileDataManager.getProfile { (profile) in
            DispatchQueue.main.async {
                self.profile = profile
                completion()
            }
        }
    }

    func saveProfile(name: String, description: String, image: UIImage, completion: @escaping CompletionSaveHandler) {
        let newProfile = Profile(name: name, description: description, userImage: image)
        profileDataManager.saveProfile(newProfile: newProfile, oldProfile: profile) { error  in
            if error == nil {
                self.profile = newProfile
            }
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }

}
