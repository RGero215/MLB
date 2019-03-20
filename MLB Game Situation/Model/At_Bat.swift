//
//  At_Bat.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/20/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit

struct At_Bat: Codable {
    let hitter_id: String
    let id: String
    let hitter_hand: String
    let pitcher_id: String
    let pitcher_hand: String
    let description: String?
    let hitter: Hitter
    let pitcher: Pitcher
    let events: [At_Bat_Event]
}
