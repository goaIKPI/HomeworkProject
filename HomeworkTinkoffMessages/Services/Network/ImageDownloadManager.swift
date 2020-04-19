//
//  ImageDownloadManager.swift
//  TinkoffChat
//
//  Created by Олег Герман on 19.04.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation

protocol IImageDownloadManager {
    var imageProvider: IImageProvider { get }
    func send(url: URL, completionImageHandler: @escaping (Data?) -> Void)
}

class ImageDownloadManager: IImageDownloadManager {
    var imageProvider: IImageProvider

    init(imageProvider: IImageProvider) {
        self.imageProvider = imageProvider
    }

    func send(url: URL, completionImageHandler: @escaping (Data?) -> Void) {
        imageProvider.downloadImage(url: url) { (result) in
            switch result {
            case .succes(let data):
                completionImageHandler(data)
            case .error:
                completionImageHandler(nil)
            }
        }
    }
}
