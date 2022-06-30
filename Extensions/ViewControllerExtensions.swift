//
//  ViewControllerExtensions.swift
//  EasyBudgeting
//
//  Created by Michael Keohane on 6/27/22.
//

import UIKit

extension UIViewController {
    
    func showActionSheet(controller: UIAlertController, actions: [UIAlertAction]) {
        for action in actions {
            controller.addAction(action)
        }
        self.present(controller, animated: true)
    }
    
    func showOkAlert(_ title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true)
    }
    
}
