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
    
    
    
    func startActivityIndicator() {
        
        
    }
    
    func stopActivityIndicator() {
        let activityIndicatorView: UIActivityIndicatorView = {
            let aiv = UIActivityIndicatorView(style: .gray)
            aiv.translatesAutoresizingMaskIntoConstraints = false
            aiv.stopAnimating()
            return aiv
        }()
        
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
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

extension CardLauncher {
    // HOME
    func homeColor(teamName: String) -> UIColor {
        var color = UIColor()
        if teamName == "Orioles" {
            color = .orange
            return color
        } else if teamName == "Red Sox" {
            color = .red
            return color
        } else if teamName == "White Sox" {
            color = .black
            return color
        } else if teamName == "Indians" {
            color = .red
            return color
        } else if teamName == "Tigers" {
            color = .blue
            return color
        } else if teamName == "Astros" {
            color = .orange
            return color
        } else if teamName == "City Royals" {
            color = .blue
            return color
        } else if teamName == "Twins" {
            color = .red
            return color
        } else if teamName == "York Yankees" {
            color = .red
            return color
        } else if teamName == "Athletics" {
            color = .green
            return color
        } else if teamName == "Mariners" {
            color = .blue
            return color
        } else if teamName == "Bay Rays" {
            color = .blue
            return color
        } else if teamName == "Rangers" {
            color = .red
            return color
        } else if teamName == "Blue Jays" {
            color = .blue
            return color
        }
        
        return color
    }
    
    // AWAY
    func awayColor(teamName: String) -> UIColor {
        var color = UIColor()
        if teamName == "Diamondbacks" {
            color = .red
            return color
        } else if teamName == "Braves" {
            color = .red
            return color
        } else if teamName == "Cubs" {
            color = .red
            return color
        } else if teamName == "Reds" {
            color = .red
            return color
        } else if teamName == "Rockies" {
            color = .black
            return color
        } else if teamName == "Angeles Dodgers" {
            color = .blue
            return color
        } else if teamName == "Marlins" {
            color = .black
            return color
        } else if teamName == "Brewers" {
            color = .blue
            return color
        } else if teamName == "York Mets" {
            color = .blue
            return color
        } else if teamName == "Phillies" {
            color = .red
            return color
        } else if teamName == "Pirates" {
            color = .yellow
            return color
        } else if teamName == "Diego Padres" {
            color = .blue
            return color
        } else if teamName == "Francisco Giants" {
            color = .orange
            return color
        } else if teamName == "Louis Cardinals" {
            color = .red
            return color
        } else if teamName == "Nationals" {
            color = .red
            return color
        }
        return color
    }
    
    // BASES
    func bases(runner: String) -> UIImage {
        
        var image = (UIImage(named: "empty_bases"))
        
        if runner == "man_on_first" {
            image = (UIImage(named: runner))
            return image!
        } else if runner == "man_on_second" {
            image = (UIImage(named: runner))
            return image!
        } else if runner == "man_on_third" {
            image = (UIImage(named: runner))
            return image!
        } else if runner == "second_and_third" {
            image = (UIImage(named: runner))
            return image!
        } else if runner == "first_and_third" {
            image = (UIImage(named: runner))
            return image!
        } else if runner == "third_and_second" {
            image = (UIImage(named: runner))
            return image!
        } else if runner == "bases_loaded" {
            image = (UIImage(named: runner))
            return image!
        }
        
        return image!
    }
    
    // OUTS
    func outs(manyOuts: String) -> UIImage {
        
        var image = (UIImage(named: "no_outs"))
        
        if manyOuts == "one_out" {
            image = (UIImage(named: manyOuts))
            return image!
        } else if manyOuts == "two_outs" {
            image = (UIImage(named: manyOuts))
            return image!
        } else if manyOuts == "three_outs" {
            image = (UIImage(named: manyOuts))
            return image!
        }
        
        return image!
    }

}

