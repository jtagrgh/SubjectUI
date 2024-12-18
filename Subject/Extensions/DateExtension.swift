//
//  DateExtensions.swift
//  Subject
//
//  Created by jakob koblinsky on 2024-12-18.
//

import Foundation

extension Date {
    func addDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: DateComponents(day: days), to: self)
            ?? self
    }

    static var tomorrow: Date {
        return .now.addDays(1)
    }
}
