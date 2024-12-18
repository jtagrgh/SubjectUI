//
//  TestRecurringEvent.swift
//  SubjectTests
//
//  Created by jakob koblinsky on 2024-12-18.
//

import Testing
import Foundation
@testable import Subject

struct TestRecurringDate {
    
    let firstOccurrence: Date = Date(timeIntervalSince1970: TimeInterval())

    @Test func oneTimeEvent() async throws {
        let event = RecurringDate(firstOccurrence: firstOccurrence,
                                   periodDays: 0,
                                  endAfter: firstOccurrence)
        
        #expect(event.occurs(at: firstOccurrence))
        #expect(!event.occurs(at: firstOccurrence.addDays(1)))
        #expect(!event.occurs(at: firstOccurrence.addingTimeInterval(1.0)))
        #expect(!event.occurs(at: firstOccurrence.addingTimeInterval(-1.0)))

        #expect(event.dates(in: DateInterval(start: firstOccurrence, end: firstOccurrence)).count == 1)
        #expect(event.dates(in: DateInterval(start: .distantPast, end: firstOccurrence)).count == 1)
        #expect(event.dates(in: DateInterval(start: firstOccurrence, end: .distantFuture)).count == 1)
        #expect(event.dates(in: DateInterval(start: .distantPast, end: .distantPast)).isEmpty)
        #expect(event.dates(in: DateInterval(start: firstOccurrence.addDays(-1), end: firstOccurrence.addDays(-1))).isEmpty)
    }
    
    @Test func dailyEvent() async throws {
        let event = RecurringDate(firstOccurrence: firstOccurrence, periodDays: 1, endAfter: firstOccurrence.addDays(10))
        
        #expect(event.dates(in: DateInterval(start: .distantPast, end: .distantFuture)).count == 11)
        #expect(event.occurs(at: firstOccurrence.addDays(1)))
        #expect(!event.occurs(at: firstOccurrence.addingTimeInterval(1.0)))
    }
    
    @Test func endBeforeStart() async throws {
        let event = RecurringDate(firstOccurrence: firstOccurrence, periodDays: 3, endAfter: firstOccurrence.addingTimeInterval(-1))
        
        #expect(event.dates(in: .eternity).isEmpty)
    }

}
