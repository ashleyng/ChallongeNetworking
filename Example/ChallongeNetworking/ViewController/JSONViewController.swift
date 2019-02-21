//
//  JSONViewController.swift
//  ChallongeNetworking_Example
//
//  Created by Ashley Ng on 11/14/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class JSONViewController: UIViewController {

    @IBOutlet weak var jsonTextView: UITextView!
    private let encodedEntityString: String
    
    init(encodedEntityString: String) {
        self.encodedEntityString = encodedEntityString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonTextView.text = encodedEntityString
    }
}
