//
//  Requests.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 19.04.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation

struct PixabayRequest: IRequest {
    var urlRequest: URLRequest?

    init(apiKey: String) {
        var urlString = "https://pixabay.com/api/"
        urlString += ("?key=" + apiKey)
        let url = URL(string: urlString)!
        urlRequest = URLRequest(url: url)
        print(url.absoluteString)
    }
}
