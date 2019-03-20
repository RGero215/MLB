//
//  PitchByPitch.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/20/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit

struct PitchByPitch {
    let id: String
    let status: String
    let home_team: String
    let away_team: String
    let double_header: Bool
    let scoring: Scoring
    let innings: [Inning]
    
    
    enum OuterCodingKey: String, CodingKey {
        case game
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case status
        case home_team
        case away_team
        case double_header
        case scoring
        case innings
        
    }
    
}

extension PitchByPitch: Decodable {
    init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: OuterCodingKey.self)
        let innerContainer = try outerContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .game)
        self.id = try innerContainer.decode(String.self, forKey: .id)
        self.status = try innerContainer.decode(String.self, forKey: .status)
        self.home_team = try innerContainer.decode(String.self, forKey: .home_team)
        self.away_team = try innerContainer.decode(String.self, forKey: .away_team)
        self.double_header = try innerContainer.decode(Bool.self, forKey: .double_header)
        self.scoring = try innerContainer.decode(Scoring.self, forKey: .scoring)
        self.innings = try innerContainer.decode([Inning].self, forKey: .innings)
        
    }
}
