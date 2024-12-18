//
//  SubjectApp.swift
//  Subject
//
//  Created by jakob koblinsky on 2024-12-03.
//

import SwiftUI
import SwiftData

enum NavigationDestination {
    case experimentListView
    case newExperimentTypeSelectionView
    case createQuantQuantExperimentView
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .experimentListView:
            ExperimentListView()
        case .newExperimentTypeSelectionView:
            NewExperimentTypeSelectionView()
        case .createQuantQuantExperimentView:
            CreateQuantQuantExperimentView()
        }
    }
}

@Observable
class NavigationController {
//    var path = [NavigationDestination]()
    var path = NavigationPath()
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    func push(_ element: any Hashable) {
        path.append(element)
    }
}


@main
struct SubjectApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Experiment.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
    
    @State var navigationController = NavigationController()
    var (container, objects) = SampleContainer.sampleMemoryContainer()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationController.path) {
                GeneralScheduleView.makeSample()
                    .navigationDestination(for: NavigationDestination.self, destination: { destination in
                        destination.view()
                    })
            }
            .environment(navigationController)
        }
        .modelContainer(container)
    }
}
