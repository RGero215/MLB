//
//  Home.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/20/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit

struct Home: Codable {
    let name: String
    let market: String
    let id: String
    let abbr: String?
    let runs: String?
    let hits: String?
    let errors: String?
    
    enum CodingKeys: String, CodingKey {
        case name, market, id, runs, hits, errors, abbr
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.market = try container.decode(String.self, forKey: .market)
        self.id = try container.decode(String.self, forKey: .id)
        if (try? container.decode(String.self, forKey: .abbr)) != nil {
            self.abbr = try container.decode(String.self, forKey: .abbr)
        } else {
            self.abbr = ""
        }
        
        if let runs = try? container.decode(Int.self, forKey: .runs) {
            self.runs = String(runs)
        } else {
            self.runs = try container.decode(String.self, forKey: .runs)
        }
        
        if let hits = try? container.decode(Int.self, forKey: .hits) {
            self.hits = String(hits)
        } else {
            self.hits = try container.decode(String.self, forKey: .hits)
        }
        
        if let errors = try? container.decode(Int.self, forKey: .errors) {
            self.errors = String(errors)
        } else {
            self.errors = try container.decode(String.self, forKey: .errors)
        }
        
    }
}
