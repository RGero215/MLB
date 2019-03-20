//
//  At_Bat_Event.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/20/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit

struct At_Bat_Event: Codable {
    let status: String?
    let id: String?
    let outcome_id: String?
    let created_at: String?
    let updated_at: String?
    let type: String?
    let flags: Flags?
    let count: Count?
    let pitcher: Pitcher?
    let hitter: Hitter?
    let runners: [Runner]?
    let hit_location: String?
    let hit_type: String?
}
