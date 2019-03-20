//
//  Hitter.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/20/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit

struct Hitter: Codable {
    let preferred_name: String
    let first_name: String
    let last_name: String
    let jersey_number: String?
    let id: String
}
