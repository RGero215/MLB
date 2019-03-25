//
//  Extensions.swift
//  MLB Game Situation
//
//  Created by Ramon Geronimo on 3/15/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}

extension String
{
    func encodeUrl() -> String?
    {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    func decodeUrl() -> String?
    {
        return self.removingPercentEncoding
    }
}

extension HomeController {
    func stadium(name: String) -> String {
        if name == "Angels"{
            return "ANGELS"
        } else if name == "Cubs"{
            return "WRINGLEY"
        } else if name == "Rangers" {
            return "ARLINGTON1"
        } else if name == "Cardinals" {
            return "BUSCH"
        } else if name == "Orioles" {
            return "CAMDEN"
        } else if name == "Mets" {
            return "CITI"
        } else if name == "Athletics" {
            return "COLISEUM"
        } else if name == "Tigers" {
            return "COMERICA PARK"
        } else if name == "Red Sox" {
            return "FENWAY"
        } else if name == "Reds" {
            return "GREAT AMERICA"
        } else if name == "Royals" {
            return "KAUFFMAN"
        } else if name == "Astros" {
            return "MINUTE MAID"
        } else if name == "Nationals" {
            return "NATIONALS"
        } else if name == "Pirates" {
            return "PNC"
        } else if name == "Blue Jays" {
            return "ROGERS"
        } else if name == "Mariners" {
            return "SAFECO MOD"
        } else if name == "Twins" {
            return "TARGET"
        } else if name == "Rays" {
            return "TROPICANA"
        } else if name == "White Sox" {
            return "US CELLULAR2"
        } else {
            return "Rising To The Top - Logo"
        }
    }
}

