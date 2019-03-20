//
//  Games.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/20/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit

struct Game: Codable {
    let id: String
    let status: String
    let home_team: String
    let away_team: String
    let double_header: Bool
    
}
