//
//  ViewController.swift
//  TouchAuth
//
//  Created by Прибыткова Зоя on 28.06.14.
//  Copyright (c) 2014 Прибыткова Зоя. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tapMeButton:UIButton
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        let accounts:NSURLCredentialStorage! = NSURLCredentialStorage.sharedCredentialStorage();
        if accounts.allCredentials.objectForKey("OurTestService") == nil {
            self.tapMeButton.setTitle("Join", forState:UIControlState.Normal)
        } else {
            self.tapMeButton.setTitle("Sign In", forState:UIControlState.Normal)
        }
    }

    @IBAction func tapMeButtonTap(sender:UIButton) {
        if sender.titleLabel.text == "Sign In" {
            processingAuthentification()
        } else {
           processingRegistration()
        }
    }
    
    func processingAuthentification() {
        self.performSegueWithIdentifier("processingAuthentification" , sender: self)
    }
    
    func processingRegistration() {
       self.performSegueWithIdentifier("processingRegistration", sender: self)
    }
    
    


}

