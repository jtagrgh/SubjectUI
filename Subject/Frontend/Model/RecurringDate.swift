//
//  RecurringEvent.swift
//  Subject
//
//  Created by jakob koblinsky on 2024-12-18.
//

import Foundation

struct RecurringDate {
    var firstOccurrence: Date
    var periodDays: Int
    var endAfter: Date
    
    /// Return a list of occurrences for the event within the inclusive range.
    func dates(in range: DateInterval) -> [Date] {
        let minEndDate: Date = min(range.end, endAfter)
        var eventDates: [Date] = []
        var addDate: Date = firstOccurrence
        while addDate <= minEndDate {
            if addDate >= range.start {
                eventDates.append(addDate)
            }
            if periodDays == 0 {
                break
            }
            addDate = addDate.addDays(periodDays)
        }
        return eventDates
    }
    
    /// Return whether an event will occur at the given date.
    func occurs(at date: Date) -> Bool {
        let dates = dates(in: DateInterval(start: date, end: date))
        return !dates.isEmpty
    }
}
