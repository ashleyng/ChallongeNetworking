//
//  CredentialsViewController.swift
//  ChallongeNetworking_Example
//
//  Created by Ashley Ng on 11/14/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

let CHALLONGE_USERNAME_KEY = "CHALLONGE_USERNAME_KEY"
class CredentialsViewController: UIViewController {

    @IBOutlet private var apiKeyTextField: UITextField!
    @IBOutlet private var usernameTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let savedUsername = UserDefaults.standard.string(forKey: CHALLONGE_USERNAME_KEY),
            let savedApiKey = try? KeychainStore.fetchKey(forUsername: savedUsername) {
            navigationController?.pushViewController(EndpointsTableViewController(username: savedUsername, apiKey: savedApiKey), animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        usernameTextField.text = ""
        apiKeyTextField.text = ""
    }
    
    @IBAction func setValuesPressed(_ sender: UIButton) {
        guard let username = usernameTextField.text,
            let apiKey = apiKeyTextField.text else {
                return
        }
        UserDefaults.standard.set(username, forKey: CHALLONGE_USERNAME_KEY)
        try? KeychainStore.saveApiKey(apiKey, forUsername: username)

        navigationController?.pushViewController(EndpointsTableViewController(username: username, apiKey: apiKey), animated: true)
    }
}

