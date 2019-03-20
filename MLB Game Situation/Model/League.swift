//
//  League.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/20/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit

struct League {
    let games: [[String:Game]]
    
    enum OuterCodingKey: String, CodingKey {
        case league
    }
    
    enum CodingKeys: String, CodingKey {
        case games
    }
}

extension League: Decodable {
    init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: OuterCodingKey.self)
        let innerContainer = try outerContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .league)
        self.games = try innerContainer.decode([[String:Game]].self, forKey: .games)
    }
}
