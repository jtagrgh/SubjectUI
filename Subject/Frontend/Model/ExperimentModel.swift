//
//  ExperimentModel.swift
//  Subject
//
//  Created by jakob koblinsky on 2024-12-04.
//

import Foundation
import SwiftData

struct HourMinute: Codable {
    var hour: Double
    var minute: Double
}

struct CoefficientEstimate: Codable {
    var lowerBound: Double
    var median: Double
    var upperBound: Double
}

struct DataPoint<T: Codable>: Identifiable, Codable {
    var id = UUID()
    var date: Date = .now
    var value: T
    var isResponse: Bool
    var label: String
    var dayStart: DayStart {
        DayStart(date: date)
    }
}

enum ObservationType: Codable {
    case quant(DataPoint<Double>)
}

struct LinearRegressionResults: Codable {
    var response: LinearRegressionResponse
    
    var coefficieintIsSig: Bool {
        response.pValues.first ?? .infinity < 0.05
    }
    
    var coefficient: Double {
        response.medians.first ?? 0
    }
    
    init() {
        response = LinearRegressionResponse()
    }
    
    init(backend: Requestable, predictors: [Double], responses: [Double]) async throws {
        let request = LinearRegressionRequest(predictors: predictors, responses: responses)
        let response = try await backend.sendRequest(request)
        if let payload = response.payload as? LinearRegressionResponse {
            self.response = payload
        } else {
            self.response = LinearRegressionResponse()
        }
    }
    
    init(backend: Requestable, observations: [DataPoint<Double>]) async throws {
        let predictors = observations.filter { $0.isResponse == false }.map { $0.value }
        let responses = observations.filter { $0.isResponse }.map{ $0.value }
        let request = LinearRegressionRequest(predictors: predictors, responses: responses)
        let response = try await backend.sendRequest(request)
        if let payload = response.payload as? LinearRegressionResponse {
            self.response = payload
        } else {
            self.response = LinearRegressionResponse()
        }
    }
}

protocol Experiment {
    var info: ExperimentInfo { get set }
}

struct ExperimentInfo: Codable {
    var name: String = ""
    var predictorPollDate: Date = Date()
    var predictorPollHourMinute: DateComponents {
        Calendar.current.dateComponents([.hour, .minute], from: predictorPollDate)
    }
    var responsePollDate: Date = Date()
    var responsePollHourMinute: DateComponents {
        Calendar.current.dateComponents([.hour, .minute], from: responsePollDate)
    }
    var predictorLabel: String = ""
    var responseLabel: String = ""
    var pollDays: Set<Int> = [1,2,3]
    var experimentStart = Date()
    var experimentEnd = Date()
}

@Model
final class QuantQuantExperiment: Experiment {
    var info = ExperimentInfo()
    var linearRegressionResults = LinearRegressionResults()
    var dirty = true
    var observations = [DataPoint<Double>]() {
        didSet {
            dirty = true
        }
    }
    
    var dayData: [DayStart: [DayDataView.DataPoint]] {
        [:]
    }
    
    func refreshResults(backend: Requestable) async throws {
        if !dirty {
            return
        }
        try await self.linearRegressionResults = LinearRegressionResults(backend: defaultTestBackend, observations: observations)
        dirty = false
    }
    
    init(info: ExperimentInfo = ExperimentInfo(), linearRegressionResults: LinearRegressionResults = LinearRegressionResults(), dirty: Bool = true, observations: [DataPoint<Double>] = [DataPoint<Double>]()) {
        self.info = info
        self.linearRegressionResults = linearRegressionResults
        self.dirty = dirty
        self.observations = observations
    }
}
