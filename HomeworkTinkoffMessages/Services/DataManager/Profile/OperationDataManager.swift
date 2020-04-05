//
//  OperationDataManager.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 15.03.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation
import UIKit

struct OperationDataManager: ProfileDataManager {
    var documentsDirectory: URL
    let operationQueue: OperationQueue

    init(queue: OperationQueue = OperationQueue()) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first else {
            fatalError()

        }
        operationQueue = queue
        self.documentsDirectory = documentsDirectory
        operationQueue.qualityOfService = .userInitiated
        operationQueue.maxConcurrentOperationCount = 1
    }

    func saveProfile(newProfile: IProfile, oldProfile: IProfile, completion: @escaping CompletionSaveHandler) {
        let saveOperation = SaveProfileOperation()
        saveOperation.completionHandler = completion
        saveOperation.newProfile = newProfile
        saveOperation.oldProfile = oldProfile
        operationQueue.addOperation(saveOperation)
    }

    func getProfile(completion: @escaping CompletionProfileLoader) {
        let loadOperation = ProfileLoadingOperation()
        loadOperation.completionHandler = completion
        operationQueue.addOperation(loadOperation)
    }
}

class ProfileLoadingOperation: Operation {
    var profile: IProfile!
    var archiveURL: URL!
    var completionHandler: CompletionProfileLoader!

    override func main() {
        guard let name = getName() else { return }
        guard let description = getDescription() else { return }
        guard let imageData = getImage() else { return }
        profile = Profile(name: name, description: description, userImage: imageData)
        OperationQueue.main.addOperation { self.completionHandler(self.profile) }
    }

    func getName() -> String? {
        guard let directory = try? FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false) as NSURL else { return nil }
        guard let fileURL = directory.appendingPathComponent("name.txt") else { return nil }
        do {
            let name = try String(contentsOf: fileURL, encoding: .utf8)
            return name

        } catch { return "" }
    }

    func getDescription() -> String? {
        guard let directory = try? FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false) as NSURL else { return nil }
        guard let fileURL = directory.appendingPathComponent("description.txt") else { return nil }
        do {
            let name = try String(contentsOf: fileURL, encoding: .utf8)
            return name

        } catch { return "" }
    }

    func getImage() -> UIImage? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory,
                                                          in: .userDomainMask).first else { return nil }
        let filePath = documentsURL.appendingPathComponent("photoPerson.png").path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)
        }
        return UIImage(named: "placeholder-user")
    }
}

class SaveProfileOperation: Operation {
    var newProfile: IProfile!
    var oldProfile: IProfile!
    var completionHandler: CompletionSaveHandler!
    var archiveURL: URL!

    override func main() {
        if newProfile.name != oldProfile.name {
            do {
                try saveName(newProfile.name)
            } catch let error {
                completionHandler(error)
            }
        }
        if newProfile.description != oldProfile.name {
            do {
                try saveName(newProfile.description)
            } catch let error {
                completionHandler(error)
            }
        }
        if newProfile.userImage != oldProfile.userImage {
            do {
                try saveImage(newProfile.userImage)
            } catch let error {
                self.completionHandler(error)
            }
        }
        OperationQueue.main.addOperation {
            self.completionHandler(nil)
        }
    }

    func saveName(_ name: String? = nil) throws {
        let file = "name.txt" //this is the file. we will write to and read from it

        let textOptional = name //just a text
        guard let text = textOptional else { return }

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let path = dir.appendingPathComponent(file)
            //writing
            do {
                try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            } catch {
                print(error.localizedDescription)
                throw error
            }
        }
    }

    func saveDescription(_ description: String? = nil) throws {
        let file = "description.txt" //this is the file. we will write to and read from it

        let textOptional = description //just a text
        guard let text = textOptional else { return }

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let path = dir.appendingPathComponent(file)
                           //writing
            do {
                try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            } catch {
                print(error.localizedDescription)
                throw error
            }
        }
    }

    func saveImage(_ image: UIImage? = nil) throws {
        guard let image = image else { return }
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil, create: false) as NSURL else {
            return
        }
        do {
            try data.write(to: directory.appendingPathComponent("photoPerson.png")!)

        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}
