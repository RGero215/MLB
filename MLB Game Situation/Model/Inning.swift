//
//  Inning.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/20/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit

struct Inning: Codable {
    let number: Int
    let sequence: Int
    let halfs: [Half]
    let scoring: Scoring?
}
