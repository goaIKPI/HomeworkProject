//
//  ServiceAssembly.swift
//  TinkoffChat
//
//  Created by Олег Герман on 19.04.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation

protocol IServiceAssembly {
    var imagesNetworkManager: NetworkManager<ImageRequestsStorageParser> { get }
    var imageDownloadManager: IImageDownloadManager { get }
}

class ServiceAssembly: NSObject, IServiceAssembly {
    var coreAssembly: ICoreAssembly

    lazy var imagesNetworkManager = NetworkManager<ImageRequestsStorageParser>(
        requestSender: coreAssembly.requestSender,
        config: coreAssembly.imageDwnldrConfig)
    lazy var imageDownloadManager: IImageDownloadManager = ImageDownloadManager(
        imageProvider: coreAssembly.imageProvider)
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
}
