//
//  ExperimentListView.swift
//  Subject
//
//  Created by jakob koblinsky on 2024-12-07.
//

import Foundation
import SwiftUI
import SwiftData

struct ExperimentListView: View {
    @Environment(\.modelContext) var modelContext
    @Query var qqExperiments: [QuantQuantExperiment]
    @Environment(NavigationController.self) var navigationController
    
    var body: some View {
        List {
            Section {
                ForEach(qqExperiments) { experiment in
                    NavigationLink(value: experiment, label: {
                        Text(experiment.info.name)
                    })
                }
                .onDelete { idxSet in
                    for idx in idxSet {
                        let model = qqExperiments[idx]
                        modelContext.delete(model)
                    }
                }
            } header: {
                Text("Running Experiments")
            }
        }
        .navigationDestination(for: QuantQuantExperiment.self, destination: { qqExperiment in
            QuantQuantExperimentView(experiment: qqExperiment, backend: defaultTestBackend)
        })
        .listStyle(.plain)
        .navigationTitle("Experiment Menu")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                NavigationLink(value: NavigationDestination.newExperimentTypeSelectionView, label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .foregroundStyle(Color(.green))
                        .frame(width: 50, height: 50)
                })
            }
        }
    }
}

//#Preview {
//    let (container, _) = SampleContainer.sampleMemoryContainerAndObject()
//    NavigationStack {
//        ExperimentListView()
//            .modelContainer(container)
//    }
//}
