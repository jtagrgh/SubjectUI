//
//  DateIntervalExtension.swift
//  Subject
//
//  Created by jakob koblinsky on 2024-12-18.
//

import Foundation

extension DateInterval {
    static var eternity: DateInterval {
        DateInterval(start: .distantPast, end: .distantFuture)
    }
}
