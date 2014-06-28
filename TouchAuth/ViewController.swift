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
    var animator: UIDynamicAnimator?
    var buttonBounds: CGRect?
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonBounds = tapMeButton.bounds
        let accounts:NSURLCredentialStorage! = NSURLCredentialStorage.sharedCredentialStorage();
        if accounts.allCredentials.objectForKey("OurTestService") == nil {
            self.tapMeButton.setImage(UIImage(named:"join"), forState: UIControlState.Normal)
            self.tapMeButton.tag = 1;
        } else {
            self.tapMeButton.setImage(UIImage(named:"signin"), forState:UIControlState.Normal)
            self.tapMeButton.tag = 2;
        }
    }

    @IBAction func tapMeButtonTap(sender:UIButton) {
        var animator = UIDynamicAnimator(referenceView: self.view)
        
        var buttonBoundsDynamicItem = PositionToBoundsMapping(target:sender)
        
        var attachmentBehavior = UIAttachmentBehavior (item: buttonBoundsDynamicItem, attachedToAnchor: buttonBoundsDynamicItem.center)
        attachmentBehavior.frequency = 2.0
        attachmentBehavior.damping = 0.3
        animator.addBehavior(attachmentBehavior)
        
        var pushBehavior = UIPushBehavior(items: [buttonBoundsDynamicItem], mode:UIPushBehaviorMode.Instantaneous)
        pushBehavior.angle = CGFloat(M_PI_4);
        pushBehavior.magnitude = 2.0;
        animator.addBehavior(pushBehavior)
        pushBehavior.active = true
        
        self.animator = animator
        if sender.tag == 2 {
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

