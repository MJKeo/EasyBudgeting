//
//  ViewExtensions.swift
//  EasyBudgeting
//
//  Created by Michael Keohane on 6/21/22.
//

import Foundation
import UIKit

extension UIView {
    
    func addTapToDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
}
