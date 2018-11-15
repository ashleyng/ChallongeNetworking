//
//  CredentialsViewController.swift
//  ChallongeNetworking_Example
//
//  Created by Ashley Ng on 11/14/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class CredentialsViewController: UIViewController {

    @IBOutlet private var apiKeyTextField: UITextField!
    @IBOutlet private var usernameTextField: UITextField!
    
    @IBAction func setValuesPressed(_ sender: UIButton) {
        guard let username = usernameTextField.text,
            let apiKey = apiKeyTextField.text else {
                return
        }
        
        present(EndpointsTableViewController(username: username, apiKey: apiKey), animated: true, completion: nil)
    }
    
}

