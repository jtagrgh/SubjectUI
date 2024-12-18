//
//  ObservationEntryView.swift
//  Subject
//
//  Created by jakob koblinsky on 2024-12-16.
//

import SwiftUI

struct ObservationEntryView: View {
    var label: String = "Enter an observation"
    @State var entry: Double?
    var onSubmit: (Double) -> Void = { _ in }
    var disableSubmit: Bool {
        entry == nil
    }

    var body: some View {
        Form {
            TextField(label, value: $entry, format: .number)
        }
        .navigationTitle("Observation Entry")
        .toolbar(content: {
            ToolbarItemGroup(placement: .topBarTrailing, content: {
                Button("Submit") {
                    if let entry = entry {
                        onSubmit(entry)
                    }
                }
                .disabled(disableSubmit)
            })
        })
    }
}

#Preview {
    ObservationEntryView()
}
