//
//  Item.swift
//  RickMortyDemo
//
//  Created by Adrián Moreno on 20/12/23.
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
