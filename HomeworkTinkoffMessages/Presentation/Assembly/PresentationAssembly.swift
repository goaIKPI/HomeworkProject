//
//  PresentationAssembly.swift
//  TinkoffChat
//
//  Created by Олег Герман on 19.04.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation

protocol IPresentationAssembly {
    var serviceAssembly: IServiceAssembly { get }
    func getImageLoaderInteractor() -> IImageLoaderInteractor
}

class PresentationAssembly: IPresentationAssembly {
    var serviceAssembly: IServiceAssembly

    func getImageLoaderInteractor() -> IImageLoaderInteractor {
        return ImageLoaderInteractor(networkManager: serviceAssembly.imagesNetworkManager,
                                     imageDownloadManager: serviceAssembly.imageDownloadManager)
    }

    init(serviceAssembly: IServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
}
