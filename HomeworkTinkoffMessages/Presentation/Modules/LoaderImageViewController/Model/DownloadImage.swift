//
//  DownloadImage.swift
//  TinkoffChat
//
//  Created by Олег Герман on 19.04.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation

protocol IImageRequestsStorage {
    var imagesURL: [ImageRequest] { get }
}

struct ImageRequestsStorage: IImageRequestsStorage, Codable {
    var imagesURL: [ImageRequest]

    enum CodingKeys: String, CodingKey {
        case imagesURL = "hits"
    }
}

struct ImageRequest: Codable {
    var url: String

    enum CodingKeys: String, CodingKey {
        case url = "userImageURL"
    }

//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        url = try container.decode(URL.self, forKey: .url)
//    }
}
