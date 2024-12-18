//
//  BackendConnection.swift
//  Subject
//
//  Created by jakob koblinsky on 2024-12-04.
//

import Foundation

let testBackendBaseUrl = URL(string: "http://192.168.2.27:5001")!
let testBackendUrl = testBackendBaseUrl.appendingPathComponent("analysis", conformingTo: .url)

enum BackendConnectionError: Error {
    case failedToInitialzie(message: String)
}

protocol Requestable {
    func sendRequest(_ request: Request) async throws -> BaseResponse
}

struct LiveBackend: Requestable {
    var url: URL
    
    func sendRequest(_ request: any Request) async throws -> BaseResponse {
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "PUT"
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        let requestData = try jsonEncoder.encode(request)
        httpRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        httpRequest.setValue("\(requestData.count)", forHTTPHeaderField: "Content-Length")
        let (responseData, _) = try await URLSession.shared.upload(for: httpRequest, from: requestData)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let responseObject = try jsonDecoder.decode(BaseResponse.self, from: responseData)
        return responseObject
    }
}

let defaultTestBackend: Requestable = {
    return LiveBackend(url: testBackendUrl)
}()
