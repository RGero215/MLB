//
//  BaseCell.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/19/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import Foundation
import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
