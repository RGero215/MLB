//
//  Event.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/20/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit

struct Event: Codable {
    let lineup: Lineup?
    let at_bat: At_Bat?
}
