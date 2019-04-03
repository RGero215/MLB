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
            color = UIColor.rgb(red: 223, green: 70, blue: 1)
            return color
        } else if teamName == "Red Sox" {
            color = UIColor.rgb(red: 189, green: 48, blue: 57)
            return color
        } else if teamName == "White Sox" {
            color = UIColor.rgb(red: 39, green: 37, blue: 31)
            return color
        } else if teamName == "Indians" {
            color = UIColor.rgb(red: 12, green: 35, blue: 64)
            return color
        } else if teamName == "Tigers" {
            color = UIColor.rgb(red: 250, green: 70, blue: 22)
            return color
        } else if teamName == "Astros" {
            color = UIColor.rgb(red: 235, green: 110, blue: 31)
            return color
        } else if teamName == "Royals" {
            color = UIColor.rgb(red: 0, green: 70, blue: 135)
            return color
        } else if teamName == "Twins" {
            color = UIColor.rgb(red: 0, green: 43, blue: 92)
            return color
        } else if teamName == "Yankees" {
            color = UIColor.rgb(red: 12, green: 35, blue: 64)
            return color
        } else if teamName == "Athletics" {
            color = UIColor.rgb(red: 0, green: 56, blue: 49)
            return color
        } else if teamName == "Mariners" {
            color = UIColor.rgb(red: 0, green: 92, blue: 92)
            return color
        } else if teamName == "Rays" {
            color = UIColor.rgb(red: 143, green: 188, blue: 230)
            return color
        } else if teamName == "Rangers" {
            color = UIColor.rgb(red: 0, green: 50, blue: 120)
            return color
        } else if teamName == "Blue Jays" {
            color = UIColor.rgb(red: 19, green: 74, blue: 142)
            return color
        } else if teamName == "Diamondbacks" {
            color = UIColor.rgb(red: 167, green: 25, blue: 48)
            return color
        } else if teamName == "Braves" {
            color = UIColor.rgb(red: 206, green: 17, blue: 65)
            return color
        } else if teamName == "Cubs" {
            color = UIColor.rgb(red: 14, green: 51, blue: 134)
            return color
        } else if teamName == "Reds" {
            color = UIColor.rgb(red: 198, green: 1, blue: 31)
            return color
        } else if teamName == "Rockies" {
            color = UIColor.rgb(red: 51, green: 0, blue: 111)
            return color
        } else if teamName == "Dodgers" {
            color = UIColor.rgb(red: 0, green: 90, blue: 156)
            return color
        } else if teamName == "Marlins" {
            color = UIColor.rgb(red: 0, green: 163, blue: 224)
            return color
        } else if teamName == "Brewers" {
            color = UIColor.rgb(red: 186, green: 146, blue: 46)
            return color
        } else if teamName == "Mets" {
            color = UIColor.rgb(red: 252, green: 89, blue: 16)
            return color
        } else if teamName == "Phillies" {
            color = UIColor.rgb(red: 232, green: 24, blue: 40)
            return color
        } else if teamName == "Pirates" {
            color = UIColor.rgb(red: 253, green: 184, blue: 39)
            return color
        } else if teamName == "Padres" {
            color = UIColor.rgb(red: 0, green: 45, blue: 98)
            return color
        } else if teamName == "Giants" {
            color = UIColor.rgb(red: 253, green: 90, blue: 30)
            return color
        } else if teamName == "Cardinals" {
            color = UIColor.rgb(red: 196, green: 30, blue: 58)
            return color
        } else if teamName == "Nationals" {
            color = UIColor.rgb(red: 171, green: 0, blue: 3)
            return color
        } else if teamName == "Angels" {
            color = UIColor.rgb(red: 186, green: 0, blue: 33)
            return color
        }
        
        return .clear
    }
    
    // AWAY
    func awayColor(teamName: String) -> UIColor {
        var color = UIColor()
        if teamName == "Orioles" {
            color = UIColor.rgb(red: 223, green: 70, blue: 1)
            return color
        } else if teamName == "Red Sox" {
            color = UIColor.rgb(red: 189, green: 48, blue: 57)
            return color
        } else if teamName == "White Sox" {
            color = UIColor.rgb(red: 39, green: 37, blue: 31)
            return color
        } else if teamName == "Indians" {
            color = UIColor.rgb(red: 12, green: 35, blue: 64)
            return color
        } else if teamName == "Tigers" {
            color = UIColor.rgb(red: 250, green: 70, blue: 22)
            return color
        } else if teamName == "Astros" {
            color = UIColor.rgb(red: 235, green: 110, blue: 31)
            return color
        } else if teamName == "Royals" {
            color = UIColor.rgb(red: 0, green: 70, blue: 135)
            return color
        } else if teamName == "Twins" {
            color = UIColor.rgb(red: 0, green: 43, blue: 92)
            return color
        } else if teamName == "Yankees" {
            color = UIColor.rgb(red: 12, green: 35, blue: 64)
            return color
        } else if teamName == "Athletics" {
            color = UIColor.rgb(red: 0, green: 56, blue: 49)
            return color
        } else if teamName == "Mariners" {
            color = UIColor.rgb(red: 0, green: 92, blue: 92)
            return color
        } else if teamName == "Rays" {
            color = UIColor.rgb(red: 143, green: 188, blue: 230)
            return color
        } else if teamName == "Rangers" {
            color = UIColor.rgb(red: 0, green: 50, blue: 120)
            return color
        } else if teamName == "Blue Jays" {
            color = UIColor.rgb(red: 19, green: 74, blue: 142)
            return color
        } else if teamName == "Diamondbacks" {
            color = UIColor.rgb(red: 167, green: 25, blue: 48)
            return color
        } else if teamName == "Braves" {
            color = UIColor.rgb(red: 206, green: 17, blue: 65)
            return color
        } else if teamName == "Cubs" {
            color = UIColor.rgb(red: 14, green: 51, blue: 134)
            return color
        } else if teamName == "Reds" {
            color = UIColor.rgb(red: 198, green: 1, blue: 31)
            return color
        } else if teamName == "Rockies" {
            color = UIColor.rgb(red: 51, green: 0, blue: 111)
            return color
        } else if teamName == "Dodgers" {
            color = UIColor.rgb(red: 0, green: 90, blue: 156)
            return color
        } else if teamName == "Marlins" {
            color = UIColor.rgb(red: 0, green: 163, blue: 224)
            return color
        } else if teamName == "Brewers" {
            color = UIColor.rgb(red: 186, green: 146, blue: 46)
            return color
        } else if teamName == "Mets" {
            color = UIColor.rgb(red: 252, green: 89, blue: 16)
            return color
        } else if teamName == "Phillies" {
            color = UIColor.rgb(red: 232, green: 24, blue: 40)
            return color
        } else if teamName == "Pirates" {
            color = UIColor.rgb(red: 253, green: 184, blue: 39)
            return color
        } else if teamName == "Padres" {
            color = UIColor.rgb(red: 0, green: 45, blue: 98)
            return color
        } else if teamName == "Giants" {
            color = UIColor.rgb(red: 253, green: 90, blue: 30)
            return color
        } else if teamName == "Cardinals" {
            color = UIColor.rgb(red: 196, green: 30, blue: 58)
            return color
        } else if teamName == "Nationals" {
            color = UIColor.rgb(red: 171, green: 0, blue: 3)
            return color
        } else if teamName == "Angels" {
            color = UIColor.rgb(red: 186, green: 0, blue: 33)
            return color
        }
        
        return .clear
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
        } else if runner == "first_and_second" {
            image = (UIImage(named: runner))
            return image!
        } else if runner == "bases_loaded" {
            image = (UIImage(named: runner))
            return image!
        }
        
        return image!
    }
    
    // OUTS
    func outs(manyOuts: Int) -> UIImage {
        
        var image = (UIImage(named: "no_outs"))
        
        if manyOuts == 1 {
            image = (UIImage(named: "one_out"))
            return image!
        } else if manyOuts == 2 {
            image = (UIImage(named: "two_outs"))
            return image!
        } else if manyOuts == 3 {
            image = (UIImage(named: "no_outs"))
            return image!
        }
        
        return image!
    }
    
    // Step
    @objc func handleStep() -> String {
        runnersImage = runners(runners: onBase, step: step)
        print("""
            
            IMAGE NAME: \(runnersImage)
            
            """)
        return runnersImage
    }
    
    // RUNNERS
    func runners(runners: [Runner], step: Int) -> String {
        var manOnFirst = false
        var manOnSecond = false
        var manOnThird = false
        var firstAndSecond = false
        var firstAndThird = false
        var secondAndThird = false
        var basesLoaded = false
        var emptyBases = true
        var score = false
        
        print("""

                Runners \(runners.count): \(runners)
            
        """)
        
        if runners.count > step {
           
            print("""
                
                Runners \(runners.count): || Steps: \(step)
                
                """)
            
            if step == 0 { return "empty_bases" }
            
            if emptyBases {
                if runners[step - 1].ending_base == 1 {
                    manOnFirst = true
                    manOnSecond = false
                    manOnThird = false
                    firstAndSecond = false
                    firstAndThird = false
                    secondAndThird = false
                    basesLoaded = false
                    emptyBases = false
                    score = false
                    return "man_on_first"
                } else if runners[step - 1].ending_base == 2 {
                    manOnFirst = false
                    manOnSecond = true
                    manOnThird = false
                    firstAndSecond = false
                    firstAndThird = false
                    secondAndThird = false
                    basesLoaded = false
                    emptyBases = false
                    score = false
                    return "man_on_second"
                } else if runners[step - 1].ending_base == 3 {
                    manOnFirst = false
                    manOnSecond = false
                    manOnThird = true
                    firstAndSecond = false
                    firstAndThird = false
                    secondAndThird = false
                    basesLoaded = false
                    emptyBases = false
                    score = false
                    return "man_on_third"
                } else if runners[step - 1].ending_base == 4 {
                    manOnFirst = false
                    manOnSecond = false
                    manOnThird = false
                    firstAndSecond = false
                    firstAndThird = false
                    secondAndThird = false
                    basesLoaded = false
                    emptyBases = true
                    score = true
                    awayRuns += 1
                    awayLabel.text = "\(awayAbbr): \(awayRuns)"
                    return "empty_bases"
                }
            }
           
            
            
//            if runners[step].ending_base == 1 && runners[1].ending_base == 2 {
//                return "first_and_second"
//            } else if runners[step].ending_base == 1 && runners[1].ending_base == 3 {
//                return "first_and_third"
//            } else if runners[step].ending_base == 1 && runners[1].ending_base == 4 {
//                return "man_on_first"
//            } else if runners[step].ending_base == 2 && runners[1].ending_base == 3 {
//                return "second_and_third"
//            } else if runners[step].ending_base == 2 && runners[1].ending_base == 4 {
//                return "man_on_second"
//            } else if runners[step].ending_base == 3 && runners[1].ending_base == 4 {
//                return "man_on_third"
//            }
//
//            if runners[step].ending_base == 1 && runners[1].ending_base == 2 && runners[2].ending_base == 3 {
//                return "bases_loaded"
//            } else if runners[step].ending_base == 1 && runners[1].ending_base == 2 && runners[2].ending_base == 4 {
//                return "first_and_second"
//            } else if runners[step].ending_base == 2 && runners[1].ending_base == 3 && runners[2].ending_base == 4 {
//                return "second_and_third"
//            } else if runners[step].ending_base == 1 && runners[1].ending_base == 3 && runners[2].ending_base == 4 {
//                return "first_and_third"
//            } else if runners[step].ending_base == 1 && runners[1].ending_base == 4 && runners[2].ending_base == 4 {
//                return "man_on_first"
//            } else if runners[step].ending_base == 2 && runners[1].ending_base == 4 && runners[2].ending_base == 4 {
//                return "man_on_second"
//            } else if runners[step].ending_base == 3 && runners[1].ending_base == 4 && runners[2].ending_base == 4 {
//                return "man_on_third"
//            }
            
            
        }
        
        
        return "empty_bases"
    }

}

