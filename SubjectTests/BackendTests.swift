//
//  BackendTests.swift
//  SubjectTests
//
//  Created by jakob koblinsky on 2024-12-06.
//

import Testing
import Foundation
@testable import Subject

struct BackendTests {
    let testBackend: Requestable = defaultTestBackend
    
    @Test("Ping backend") func sendPing() async throws {
        let request = PingRequest()
        let response = try await self.testBackend.sendRequest(request)
        
        #expect(response.status == "ok")
        #expect(response.errorMessage == "")
        #expect(response.payloadType == .ping_response)
        #expect(response.payload is PingResponse)
        let payload = response.payload as! PingResponse
        #expect(payload.message == "pong")
    }
    
    @Test("Ping OLS endpoint") func requestOls() async throws {
        let predictors: [Double] = [1,2,3,4,5,6]
        let responses: [Double] = [1,2,3,4,5,6]
        let request = LinearRegressionRequest(predictors: predictors, responses: responses)
        let response = try await self.testBackend.sendRequest(request)
        
        #expect(response.status == "ok")
    }
    
    @Test("Fail OLS b.c. not enough datapoints") func failOls() async throws {
        let predictors = [1.0,2.0]
        let responses = [1.0]
        let request = LinearRegressionRequest(predictors: predictors, responses: responses)
        await #expect(throws: (any Error).self, nil, performing: { try await self.testBackend.sendRequest(request) })
    }

}
