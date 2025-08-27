//
//  Item.swift
//  PawsePrint
//
//  Created by Rachael Bergeron on 8/12/25.
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
