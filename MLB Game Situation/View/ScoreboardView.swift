//
//  ScoreboardView.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/23/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import UIKit

class ScoreboardView: UIView {
    
    let controlsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "back-arrow")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleDismiss(){
        print("Dismiss....")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissView"), object: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        controlsView.frame = frame
        addSubview(controlsView)
        
        controlsView.addSubview(dismissButton)

        dismissButton.trailingAnchor.constraint(equalTo: controlsView.trailingAnchor, constant: 0).isActive = true
        dismissButton.topAnchor.constraint(equalTo: controlsView.topAnchor, constant: 0).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        backgroundColor = .black
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
