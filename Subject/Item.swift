//
//  Item.swift
//  Subject
//
//  Created by jakob koblinsky on 2024-12-03.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
