//
//  ExperimentView.swift
//  Subject
//
//  Created by jakob koblinsky on 2024-12-06.
//

import SwiftUI
import SwiftData

struct QuantQuantExperimentView: View {
    var experiment: QuantQuantExperiment
    var linearRegressionResults: LinearRegressionResults
    let backend: Requestable
    @Environment(NavigationController.self) var navigationController
    
    init(experiment: QuantQuantExperiment, backend: Requestable) {
        self.experiment = experiment
        self.linearRegressionResults = experiment.linearRegressionResults
        self.backend = backend
    }

    @State var showRawData = false
    @State var fetching = false
    
    enum Routes {
        case scheduleView
    }
    
    var body: some View {
        List {
            Section("Info") {
                Text(experiment.info.name)
                    .font(.title)
            }
            Section("Results") {
//                Text("Let's see how **\(experiment.info.predictorLabel)** affect **\(experiment.info.responseLabel)**")
//                if fetching {
//                    ProgressView()
//                } else {
//                    if !experiment.linearRegressionResults.coefficieintIsSig {
//                        Text("No statistically significant connection found.")
//                        if experiment.predictors.count < 10 {
//                            Text("Try recording more data.")
//                        }
//                    } else {
//                        Text("A statistically significant connection has been found") + Text("Increasing **\(experiment.info.predictorLabel)** by 1x,") + Text("increases **\(experiment.info.responseLabel)** by \(experiment.linearRegressionResults.coefficient.formatted())x")
//                    }
//                }
            }
            Section("Controls") {
                NavigationLink(value: Routes.scheduleView, label: {
                    Text("Schedule")
                })
            }
        }
        .listStyle(.plain)
        .task {
            fetching = true
//            try? await experiment.refreshResults(backend: defaultTestBackend)
            fetching = false
        }
        .navigationTitle("Details")
        .navigationDestination(for: Routes.self, destination: { route in
            switch(route) {
            case .scheduleView:
                Text("Schedule here")
            }
        })
    }
}

#Preview {
    let navigationController = NavigationController()
    let (container, objects) = SampleContainer.sampleMemoryContainer()
    NavigationStack {
        QuantQuantExperimentView(experiment: objects[0] as! QuantQuantExperiment, backend: defaultTestBackend)
            .modelContainer(container)
            .environment(navigationController)
    }
}
