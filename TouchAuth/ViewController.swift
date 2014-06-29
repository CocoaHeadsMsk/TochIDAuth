//
//  ViewController.swift
//  TouchAuth
//
//  Created by Прибыткова Зоя on 28.06.14.
//  Copyright (c) 2014 Прибыткова Зоя. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet var tapMeButton:UIButton
    @IBOutlet var backgroundImageView:UIImageView
    @IBOutlet var registrationView:UIView
    var animator: UIDynamicAnimator?
    var buttonBounds: CGRect?
    let protectionSpace = AppProtectionSpace.sharedInstance()
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registrationView.alpha = 0;
        buttonBounds = tapMeButton.bounds
        let account:NSURLCredentialStorage! = NSURLCredentialStorage.sharedCredentialStorage();
        if account.defaultCredentialForProtectionSpace(self.protectionSpace.space) == nil {
            self.tapMeButton.setImage(UIImage(named:"join"), forState: UIControlState.Normal)
            self.tapMeButton.tag = 1;
        } else {
            self.tapMeButton.setImage(UIImage(named:"signin"), forState:UIControlState.Normal)
            self.tapMeButton.tag = 2;
        }
        
        let blur = UIVisualEffectView(effect:UIBlurEffect(style:.Light)) as UIVisualEffectView
        blur.frame = self.view.bounds
        self.backgroundImageView.addSubview(blur)
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
            self.processingAuthentification()
        } else {
            self.processingRegistration()
        }
    }
    
    func processingRegistration() {
        UIView.animateWithDuration(2.6, animations: {
            self.tapMeButton.alpha = 0
            self.registrationView.alpha = 1
            })
    }
    
    func processingAuthentification() {
        var context = LAContext()
        let myCredential = NSURLCredentialStorage.sharedCredentialStorage().defaultCredentialForProtectionSpace(self.protectionSpace.space)
        context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason:"You use login: \(myCredential.user)") {
            (success: Bool, error: NSError!) -> Void in
            if success {
                println("Auth success! LOGIN: \(myCredential.user). PASSWORD: \(myCredential.password)")
            } else {
                switch (error.code) {
                case LAError.AuthenticationFailed.toRaw():
                    println("Authentication Failed")
                    
                case LAError.UserCancel.toRaw():
                    println("User pressed Cancel button")
                    
                case LAError.UserFallback.toRaw():
                    println("User pressed \"Enter Password\"")
                    
                default: break;
                }
            }
        }
    }
}

