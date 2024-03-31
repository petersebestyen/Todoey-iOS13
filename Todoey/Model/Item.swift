//
//  Item.swift
//  Todoey
//
//  Created by Péter Sebestyén on 2024.03.30.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

class Item: Codable {
    var title: String
    var done:  Bool
    
    init(title: String, done: Bool) {
        self.title = title
        self.done = done
    }
}
