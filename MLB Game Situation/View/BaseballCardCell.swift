//
//  BaseballCardCell.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/15/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import Foundation
import UIKit

class BaseballCardCell: BaseCell {
    
    
    let baseballCardView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rising2dtop stadium")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Headshot")
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title Text - Placeholder"
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Subtitle Text - Placeholder is longer than the title for a detail description of the event"
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        textView.textColor = UIColor.lightGray
        return textView
    }()
    
    override func setupViews() {
        addSubview(baseballCardView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: baseballCardView)
        
        addConstraintsWithFormat(format: "H:|-16-[v0(100)]", views: userProfileImageView)
        
        //Vertical constraints
        addConstraintsWithFormat(format: "V:|-16-[v0]-8-[v1(100)]-16-[v2(1)]|", views: baseballCardView,userProfileImageView, separatorView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        
        //Top Constraints
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: baseballCardView, attribute: .bottom, multiplier: 1, constant: 8))
        //Left Constraints
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        //Right constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: baseballCardView, attribute: .right, multiplier: 1, constant: 0))
        
        //Height constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 46))
        
        //Top Constraints
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        //Left Constraints
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        //Right constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: baseballCardView, attribute: .right, multiplier: 1, constant: 0))
        
        //Height constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 46))
    }
    
}
