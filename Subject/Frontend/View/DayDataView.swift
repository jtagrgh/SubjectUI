//
//  DayDataView.swift
//  Subject
//
//  Created by jakob koblinsky on 2024-12-13.
//

import SwiftUI

struct DayDataView: View {
    var dataPoints: [DataPoint] = []
    var onDelete: (IndexSet) -> Void = {_ in}
    var onEdit: (DataPoint) -> Void = {_ in}
    
    struct DataPoint: Identifiable {
        var id = UUID()
        var caption: String
        var value: Double
        var editDisabled: Bool = false
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(dataPoints) { dataPoint in
                    HStack {
                        Text(dataPoint.caption)
                            .font(.caption)
                        Text(dataPoint.value.formatted())
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        if !dataPoint.editDisabled {
                            Button("Edit", action: { onEdit(dataPoint) })
                        }
                    }
                }
                .onDelete(perform: onDelete)
            }
            .listStyle(.plain)
        }
    }
}

extension DayDataView {
    static func sampleDataPoints() -> [DataPoint] {
        return [("Caption 1:", 1.0),
                ("Caption 2:", 2.0)]
            .map({ DataPoint(caption: $0.0, value: $0.1) })
    }
    
    static func makeSample() -> some View {
        return DayDataView(dataPoints: sampleDataPoints())
    }
}

#Preview {
    DayDataView.makeSample()
}
