//
//  Away.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/20/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit

struct Away: Codable {
    let name: String
    let market: String
    let abbr: String?
    let id: String
    let runs: Int
    let hits: Int
    let errors: Int
}
