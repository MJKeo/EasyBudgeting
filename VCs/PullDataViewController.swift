//
//  PullDataViewController.swift
//  EasyBudgeting
//
//  Created by Michael Keohane on 6/29/22.
//

import UIKit

class PullDataViewController: UIViewController {
    
    struct APIKey {
        let clientId = "62bcdbb03ac82700132b5b1a"
        let secret = "455c0b835f46902f11e522ff5f9a01"
        let username: String
        let password: String
        
        init(username: String, password: String) {
            self.username = username
            self.password = password
        }
    }
    
    private var apiKey = APIKey(username: "user_good", password: "pass_good")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
