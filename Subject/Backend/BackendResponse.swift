//
//  BackendRequests.swift
//  Subject
//
//  Created by jakob koblinsky on 2024-12-04.
//

import Foundation

enum PayloadType: String, Decodable {
    case linear_regression_response
    case ping_response
    case fail_response

    func associatedType() -> Decodable.Type {
        switch self {
        case .linear_regression_response:
            return LinearRegressionResponse.self
        case .ping_response:
            return PingResponse.self
        case .fail_response:
            return FailResponse.self
        }
    }
}

struct LinearRegressionResponse: Codable {
    var lowerBounds: [Double] = []
    var medians: [Double] = []
    var upperBounds: [Double] = []
    var pValues: [Double] = []
}

struct PingResponse: Decodable {
    var message: String
}

struct FailResponse: Decodable {
}

struct BaseResponse: Decodable {
    internal init(status: String, errorMessage: String, payloadType: PayloadType, payload: any Decodable) {
        self.status = status
        self.errorMessage = errorMessage
        self.payloadType = payloadType
        self.payload = payload
    }
    
    var status: String
    var errorMessage: String
    var payloadType: PayloadType
    var payload: Decodable
    
    private enum CodingKeys: String, CodingKey {
        case status
        case errorMessage
        case payloadType
        case payload
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        self.errorMessage = try container.decode(String.self, forKey: .errorMessage)
        self.payloadType = try container.decode(PayloadType.self, forKey: .payloadType)
        self.payload = try container.decode(payloadType.associatedType(), forKey: .payload)
    }
}
