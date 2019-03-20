//
//  Lineup.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/20/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit

struct Lineup: Codable {
    let player_id: String
    let order: Int
    let position: Int
    let team_id: String
    let preferred_name: String
    let first_name: String
    let last_name: String
    let jersey_number: String?
    let id: String
}
