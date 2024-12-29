//
//  Item.swift
//  Roll'd
//
//  Created by Will Nixon on 12/29/24.
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
