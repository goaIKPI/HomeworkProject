//
//  CoreAssembly.swift
//  TinkoffChat
//
//  Created by Олег Герман on 19.04.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var coreDataStack: CoreDataStack { get }
    var requestSender: IRequestSender { get }
    var imageDwnldrConfig: RequestConfig<ImageRequestsStorageParser> { get }
    var imageProvider: IImageProvider { get }
}

class CoreAssembly: ICoreAssembly {
    lazy var coreDataStack: CoreDataStack = NestedWorkersCoreDataStack.shared
    lazy var requestSender: IRequestSender = RequestSender()
    lazy var imageDwnldrConfig = RequestsFactory.ImageLoaderFactory.imageDownloaderConfig()
    lazy var imageProvider: IImageProvider = ImageProvider.shared
}
