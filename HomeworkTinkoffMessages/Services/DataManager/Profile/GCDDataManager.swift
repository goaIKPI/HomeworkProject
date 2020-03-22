//
//  GCDDataManager.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 15.03.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation
import UIKit

class GCDDataManager: ProfileDataManager {
    
    let syncQueue = DispatchQueue(label: "com.tinkoffchat", qos: .userInitiated)
    
    func saveName(_ name: String? = nil) throws {
        let file = "name.txt" //this is the file. we will write to and read from it

        let textOptional = name //just a text
        guard let text = textOptional else { return }

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let path = dir.appendingPathComponent(file)
            //writing
            do {
                try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {
                print(error.localizedDescription)
                throw error
            }
        }
    }
    
    
    func saveDescription(_ description: String? = nil) throws{
        let file = "description.txt" //this is the file. we will write to and read from it

        let textOptional = description //just a text
        guard let text = textOptional else { return }

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let path = dir.appendingPathComponent(file)
                        //writing
            do {
                try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {
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
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return
        }
        do {
            try data.write(to: directory.appendingPathComponent("photoPerson.png")!)

        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func getName() throws -> String? {
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else { return nil }
        guard let fileURL = directory.appendingPathComponent("name.txt") else { return nil }
        do {
            let name = try String(contentsOf: fileURL, encoding: .utf8)
            return name
            
        }
        catch { return nil }
    }
    
    
    func getDescription() throws -> String? {
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else { return nil }
        guard let fileURL = directory.appendingPathComponent("description.txt") else { return nil }
        do {
            let name = try String(contentsOf: fileURL, encoding: .utf8)
            return name
            
        }
        catch { throw error }
    }
    
    func getImage() -> UIImage? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let filePath = documentsURL.appendingPathComponent("photoPerson.png").path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)
        }
        return nil
    }
    
    func getProfile(completion: @escaping (IProfile)->()) {
        syncQueue.async {
            do {
                guard let name = try? self.getName() else { return }
                guard let description = try? self.getDescription() else { return }
                guard let image = self.getImage() else { return }
                let profile = Profile(name: name, description: description, userImage: image)
                completion(profile)
            }
            
        }
    }
    
    func saveProfile(newProfile: IProfile, oldProfile: IProfile, completion: @escaping CompletionSaveHandler) {
        syncQueue.async {
            if newProfile.name != oldProfile.name {
                do {
                    try self.saveName(newProfile.name)
                } catch let error {
                    DispatchQueue.main.async {
                        completion(error)
                        return
                    }
                }
            }
            if newProfile.description != oldProfile.description {
                do {
                    try self.saveDescription(newProfile.description)
                } catch let error {
                    DispatchQueue.main.async {
                        completion(error)
                        return
                    }
                }
                
            }
            if newProfile.userImage != oldProfile.userImage {
                do {
                    try self.saveImage(newProfile.userImage)
                } catch let error {
                    DispatchQueue.main.async {
                        completion(error)
                        return
                    }
                }
            }
            completion(nil)
            
        }
    }
}
