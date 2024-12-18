//
//  QuantQuantScheduleView.swift
//  Subject
//
//  Created by jakob koblinsky on 2024-12-12.
//

import SwiftUI

typealias DayStartToDataPointMap = [DayStart: [DayDataView.DataPoint]]

struct GeneralScheduleView: View {
    @Environment(NavigationController.self) var navigationController
    @State var selectedDate: DayStart = DayStart(date: .distantFuture)
    @State var showDayDataSheet = false
    var startDate: Date = .now.addDays(-1)
    var endDate: Date = .tomorrow
    var dateData: DayStartToDataPointMap = [:]
    var dayMarks: [DayStart: DayMark] = [:]
    var selectedData: [DayDataView.DataPoint] {
        dateData[selectedDate] ?? []
    }

    var body: some View {
        VStack(alignment: .leading) {
            CalendarView(
                interval: DateInterval(start: startDate, end: endDate),
                markedDays: dayMarks,
                selectedDate: $selectedDate,
                experimentEndDate: DayStart(date: endDate)
            )
            .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .navigationTitle("Schedule")
        .sheet(isPresented: $showDayDataSheet, content: {
            VStack {
                Text("Observations")
                    .font(.headline)
                    .padding(.top)
                List {
                    ForEach(selectedData) { dataPoint in
                        HStack {
                            Text(dataPoint.caption)
                                .font(.caption)
                            Text(dataPoint.value.formatted())
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            if !dataPoint.editDisabled {
                                Button("Edit", action: {
                                    // Edit Action
                                })
                            }
                        }
                    }
                    .onDelete(perform: {_ in 
                        // Delete Action
                    })
                }
                .listStyle(.plain)
            }
            .presentationDetents([.fraction(0.3)])
        })
        .onChange(of: selectedDate, {
            if selectedData.count > 0 {
                showDayDataSheet.toggle()
            }
        })
    }
}

extension GeneralScheduleView {
    static func sampleDayData() -> DayStartToDataPointMap {
        let dataPoints = DayDataView.sampleDataPoints()
        let today = DayStart(date: .now)
        return [today: dataPoints]
    }
    
    static func makeSample() -> some View {
        return Self(dateData: sampleDayData())
    }
}

struct DayStart: Hashable, Equatable, Comparable {
    let date: Date
    var value: Date {
        Calendar.current.startOfDay(for: date)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }

    static func == (lhs: DayStart, rhs: DayStart) -> Bool {
        return lhs.value == rhs.value
    }

    static func < (lhs: DayStart, rhs: DayStart) -> Bool {
        return lhs.value < rhs.value
    }
}

extension Date {
    func addDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: DateComponents(day: days), to: self)
            ?? self
    }

    static var tomorrow: Date {
        return .now.addDays(1)
    }
}

#Preview {
    NavigationStack {
//        QuantQuantScheduleView.makeSample()
    }
    .environment(NavigationController())
}
