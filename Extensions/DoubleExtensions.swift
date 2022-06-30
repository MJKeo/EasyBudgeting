//
//  DoubleExtensions.swift
//  EasyBudgeting
//
//  Created by Michael Keohane on 6/21/22.
//

import Foundation

extension Double {
    
    func toDollar() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }
    
}
