//
//  RequestConfig.swift
//  HomeworkTinkoffMessages
//
//  Created by Олег Герман on 19.04.2020.
//  Copyright © 2020 Олег Герман. All rights reserved.
//

import Foundation

protocol IRequest {
    var urlRequest: URLRequest? { get }
}

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}

enum RequestResult<T> {
    case succes(T)
    case error(String)
}

struct RequestConfig<Parser: IParser> {
    var request: IRequest
    var parser: Parser
}
