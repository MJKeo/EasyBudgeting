//
//  DateExtensions.swift
//  EasyBudgeting
//
//  Created by Michael Keohane on 6/22/22.
//

import Foundation

extension Date {
    
    private func formatDate(_ formatString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.string(from: self)
    }
    
    public func toYYYYMMDD() -> String {
        return formatDate("YYYY-MM-dd")
    }
    
    public func toMonthYear() -> String {
        return formatDate("MMMM YYYY")
    }
    
    public func toMMDD() -> String {
        return formatDate("M/d")
    }
    
}
