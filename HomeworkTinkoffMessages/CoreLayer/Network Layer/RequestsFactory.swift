//
//  RequestsFactory.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 19.04.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation

struct RequestsFactory {
    struct ImageLoaderFactory {
        static func imageDownloaderConfig() -> RequestConfig<ImageRequestsStorageParser> {
            return RequestConfig<ImageRequestsStorageParser>(request:
                PixabayRequest(apiKey: "16102759-5d1761533656582d920916f7c"),
                                                        parser: ImageRequestsStorageParser())
        }
    }
}
