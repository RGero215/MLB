//
//  Pitcher.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/20/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit

struct Pitcher: Codable{
    let preferred_name: String
    let first_name: String
    let last_name: String
    let jersey_number: String?
    let id: String
    let pitch_type: String?
    let pitch_speed: Int?
    let pitch_zone: Int?
    let pitcher_hand: String?
    let hitter_hand: String?
    let pitch_count: Int?
    let pitch_x: Int?
    let pitch_y: Int?
    
}
