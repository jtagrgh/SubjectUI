//
//  NewExperimentTypeSelectionView.swift
//  Subject
//
//  Created by jakob koblinsky on 2024-12-08.
//

import SwiftUI
import SwiftData

struct NewExperimentTypeSelectionView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(NavigationController.self) var navigationController

    var body: some View {
        List {
            NavigationLink(value: NavigationDestination.createQuantQuantExperimentView, label: {
                Text("Number Number")
            })
        }
    }
    
}

#Preview {
    let (container, _) = SampleContainer.sampleMemoryContainer()
    NavigationStack {
        NewExperimentTypeSelectionView()
            .modelContainer(container)
    }
}
