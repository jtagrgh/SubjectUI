//
//  CalendarView.swift
//  Subject
//
//  Created by jakob koblinsky on 2024-12-12.
//

import SwiftUI

enum DayMark {
    case filled
    case future
    case missing
    
    func imageMark() -> UICalendarView.Decoration {
        switch self {
        case .filled:
            .image(UIImage(systemName: "circle.fill"), color: .green)
        case .future:
            .image(UIImage(systemName: "circle"))
        case .missing:
            .image(UIImage(systemName: "circle.circle"), color: .red)
        }
    }
}

typealias DayMarkMap = [DayStart: DayMark]

struct CalendarView: UIViewRepresentable {
    let interval: DateInterval
    let markedDays: DayMarkMap
    @Binding var selectedDate: DayStart
    let experimentEndDate: DayStart
    
    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        view.delegate = context.coordinator
        view.calendar = Calendar.current
        view.availableDateRange = interval
        let dateSelection =  UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.selectionBehavior = dateSelection
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, @preconcurrency UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: CalendarView
        
        init(parent: CalendarView) {
            self.parent = parent
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            if let date = dateComponents?.date {
                parent.selectedDate = DayStart(date: date)
            }
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
             return true
        }
        
        @MainActor
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            guard let date: Date = dateComponents.date else {
                return nil
            }
            let monthDayYear = DayStart(date: date)
            if monthDayYear >= DayStart(date: .tomorrow) && monthDayYear <= parent.experimentEndDate {
                return .image(UIImage(systemName: "circle"), color: .gray)
            }
            if let mark = parent.markedDays[monthDayYear] {
                return mark.imageMark()
            }
            return nil
        }
    }
}
