//
//  ImageDownloaderParser.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 19.04.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation

struct ImageRequestsStorageParser: IParser {
    typealias Model = ImageRequestsStorage

    func parse(data: Data) -> ImageRequestsStorage? {
        let jsonDecoder = JSONDecoder()
        let imageDownloader = try? jsonDecoder.decode(ImageRequestsStorage.self, from: data)
        return imageDownloader
    }
}
