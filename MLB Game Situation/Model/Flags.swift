//
//  Flags.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/20/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit

struct Flags: Codable {
    let is_ab_over: Bool
    let is_bunt: Bool
    let is_bunt_shown: Bool
    let is_hit: Bool
    let is_wild_pitch: Bool
    let is_passed_ball: Bool
    let is_double_play: Bool
    let is_triple_play: Bool
}
