//
//  BackendRequest.swift
//  Subject
//
//  Created by jakob koblinsky on 2024-12-04.
//

import Foundation

protocol Request: Encodable {
    var type: String { get }
}

struct LinearRegressionRequest: Request {
    var type = "linear_regression"
    var predictors: [Double]
    var responses: [Double]
}

struct PingRequest: Request {
    var type = "ping"
    var message: String = "ping"
}
