//
//  CreateQuantQuantExperimentView.swift
//  Subject
//
//  Created by jakob koblinsky on 2024-12-08.
//

import SwiftUI
import SwiftData

struct CreateQuantQuantExperimentView: View {
    @State var model = QuantQuantExperiment()
    @Environment(\.modelContext) var modelContext
    @Environment(NavigationController.self) var navigationController
    
    var afterStartDate: PartialRangeFrom<Date> {
        return model.info.experimentStart...
    }
        
    var body: some View {
        Form {
            TextField("Experiment name", text: $model.info.name)
            DatePicker("Predictor notification time", selection: $model.info.predictorPollDate, displayedComponents: .hourAndMinute)
            DatePicker("Response notification time", selection: $model.info.responsePollDate, displayedComponents: .hourAndMinute)
            DatePicker("Start date", selection: $model.info.experimentStart, displayedComponents: .date)
            DatePicker("End date", selection: $model.info.experimentEnd, in: afterStartDate, displayedComponents: .date)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button("Save") {
                    modelContext.insert(model)
                    navigationController.popToRoot()
                }
            })
        }
    }
}

#Preview {
    NavigationStack {
        let (container, objects) = SampleContainer.sampleMemoryContainer()
        CreateQuantQuantExperimentView(model: objects[0] as! QuantQuantExperiment)
            .modelContainer(container)
            .environment(NavigationController())
    }
}
