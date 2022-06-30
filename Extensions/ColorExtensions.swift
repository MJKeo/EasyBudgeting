//
//  ColorExtensions.swift
//  EasyBudgeting
//
//  Created by Michael Keohane on 6/26/22.
//

import UIKit

extension UIColor {
    
    static func createColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
    // Saving these in case they're useful
//    static let indigoDye = createColor(red: 27, green: 73, blue: 101)
//    static let violetCrayola = createColor(red: 138, green: 73, blue: 117)
    static let carolinaBlue = createColor(red: 95, green: 168, blue: 211)
//    static let oldRose = createColor(red: 201, green: 128, blue: 139)
//    static let seaGreen = createColor(red: 56, green: 134, blue: 89)
    static let fireOpal = createColor(red: 226, green: 81, blue: 67)
    
    static let backgroundColors = [
        createColor(red: 43, green: 25, blue: 61),
        createColor(red: 44, green: 54, blue: 94),
        createColor(red: 72, green: 77, blue: 109),
        createColor(red: 147, green: 162, blue: 208),
        createColor(red: 75, green: 143, blue: 140),
        createColor(red: 225, green: 106, blue: 102),
    ]
    
}
