//
//  StringExtensions.swift
//  EasyBudgeting
//
//  Created by Michael Keohane on 6/21/22.
//

import Foundation

extension String {
    
    func toDouble() -> Double {
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: [])
        let strippedText = regex.stringByReplacingMatches(in: self, range: NSMakeRange(0, self.count), withTemplate: "")
        return Double(strippedText) ?? 0
    }
    
    func dateFromYYYYMMDD() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.date(from: self)!
    }
}
