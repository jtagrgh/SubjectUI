//
//  SampleContainers.swift
//  Subject
//
//  Created by jakob koblinsky on 2024-12-06.
//

import Foundation
import SwiftData

@MainActor
struct SampleContainer {

    static public func sampleMemoryContainer() -> (ModelContainer, [any PersistentModel]) {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(
            for: QuantQuantExperiment.self, configurations: config)

        var experimentList = [any PersistentModel]()
        experimentList.append(
            QuantQuantExperiment(
                info: ExperimentInfo(
                    name: "Coffee vs. Productive Hours",
                    predictorPollDate: Date(),
                    responsePollDate: Date(),
                    predictorLabel: "Litres of Coffee",
                    responseLabel: "Productive Hours",
                    pollDays: [1, 2, 3],
                    experimentStart: .now.addDays(-7),
                    experimentEnd: .now.addDays(7)
                ),
                observations: [
                    DataPoint<Double>(date: .now.addDays(-3), value: 1.0, isResponse: false, label: "Litres of Coffee"),
                    DataPoint<Double>(date: .now.addDays(-2), value: 2.0, isResponse: false, label: "Litres of Coffee"),
                    DataPoint<Double>(date: .now.addDays(-1), value: 3.0, isResponse: false, label: "Litres of Coffee"),
                    DataPoint<Double>(date: .now.addDays(0) , value: 4.0, isResponse: false, label: "Litres of Coffee"),
                    DataPoint<Double>(date: .now.addDays(-3), value: 1.0, isResponse: true, label: "Productive Hours"),
                    DataPoint<Double>(date: .now.addDays(-2), value: 2.0, isResponse: true, label: "Productive Hours"),
                    DataPoint<Double>(date: .now.addDays(-1), value: 3.0, isResponse: true, label: "Productive Hours"),
                    DataPoint<Double>(date: .now.addDays(0) , value: 4.0, isResponse: true, label: "Productive Hours"),
                ]
            )
        )
        experimentList.append(
            QuantQuantExperiment(
                info: ExperimentInfo(
                    name: "Coffee vs. Productive Hours 2",
                    predictorPollDate: Date(),
                    responsePollDate: Date(),
                    predictorLabel: "Litres of Coffee",
                    responseLabel: "Productive Hours",
                    pollDays: [1, 2, 3]
                ),
                observations: [
                    DataPoint<Double>(value: 1.0, isResponse: false, label: "Litres of Coffee"),
                    DataPoint<Double>(value: 2.0, isResponse: false, label: "Litres of Coffee"),
                    DataPoint<Double>(value: 3.0, isResponse: false, label: "Litres of Coffee"),
                    DataPoint<Double>(value: 4.0, isResponse: false, label: "Litres of Coffee"),
                    DataPoint<Double>(value: 1.0, isResponse: true, label: "Productive Hours"),
                    DataPoint<Double>(value: 2.0, isResponse: true, label: "Productive Hours"),
                    DataPoint<Double>(value: 3.0, isResponse: true, label: "Productive Hours"),
                    DataPoint<Double>(value: 4.0, isResponse: true, label: "Productive Hours"),
                ]
            )
        )
        
        for experiment in experimentList {
            container.mainContext.insert(experiment)
        }

        try! container.mainContext.save()
        return (container, experimentList)
    }

}
