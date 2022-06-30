//
//  TextViewExtensions.swift
//  EasyBudgeting
//
//  Created by Michael Keohane on 6/27/22.
//

import Foundation
import UIKit

class DollarTextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    func convertToDollar() {
        if let text = self.text {
            let regex = try! NSRegularExpression(pattern: "[^0-9]", options: [])
            let strippedText = regex.stringByReplacingMatches(in: text, range: NSMakeRange(0, text.count), withTemplate: "")
            let amount = (Double(strippedText) ?? 0) / 100
            self.text = amount.toDollar()
        }
    }
    
}
