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
    @IBOutlet var backgroundImageView:UIImageView
    @IBOutlet var registrationView:UIView
    var animator: UIDynamicAnimator?
    var buttonBounds: CGRect?
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registrationView.alpha = 0;
        buttonBounds = tapMeButton.bounds
        let accounts:NSURLCredentialStorage! = NSURLCredentialStorage.sharedCredentialStorage();
        if accounts.allCredentials.objectForKey("OurTestService") == nil {
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
//            processingAuthentification()
        } else {
            self.processingRegistration()
        }
    }
    
    func processingRegistration() {
        UIView.animateWithDuration(1.0, animations: {
            self.tapMeButton.alpha = 0
            self.registrationView.alpha = 1
            })
    }
    
    


}

class RegistrationViewController:UIViewController, UITextFieldDelegate {
    
    @IBOutlet var repeatPassword:       UITextField
    @IBOutlet var loginTextField:       UITextField
    @IBOutlet var passwordTextField:    UITextField
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.repeatPassword.delegate = self
        self.loginTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    @IBAction func loginTextFielBeginEditing(sender:UITextField) {
        self.repeatPassword.transform = CGAffineTransformMakeTranslation(0, -25)
        self.loginTextField.transform = CGAffineTransformMakeTranslation(0, -25)
        self.passwordTextField.transform = CGAffineTransformMakeTranslation(0, -25)
    }
    
    @IBAction func loginTextFieldEndEditing(sender:UITextField) {
        self.repeatPassword.transform = CGAffineTransformMakeTranslation(0, 0)
        self.loginTextField.transform = CGAffineTransformMakeTranslation(0, 0)
        self.passwordTextField.transform = CGAffineTransformMakeTranslation(0, 0)
    }
    
    @IBAction func passwordTextFieldBeginEditing(sender:UITextField) {
        self.repeatPassword.transform = CGAffineTransformMakeTranslation(0, -85)
        self.loginTextField.transform = CGAffineTransformMakeTranslation(0, -85)
        self.passwordTextField.transform = CGAffineTransformMakeTranslation(0, -85)
    }
    
    @IBAction func passwordTextFieldEndEditing(sender:UITextField) {
       self.repeatPassword.transform = CGAffineTransformMakeTranslation(0, 0)
        self.loginTextField.transform = CGAffineTransformMakeTranslation(0, 0)
        self.passwordTextField.transform = CGAffineTransformMakeTranslation(0, 0)
    }
    
    @IBAction func repeatPasswordTextFieldBeginEditing(sender:UITextField) {
        self.repeatPassword.transform = CGAffineTransformMakeTranslation(0, -145)
        self.loginTextField.transform = CGAffineTransformMakeTranslation(0, -145)
        self.passwordTextField.transform = CGAffineTransformMakeTranslation(0, -145)
    }
    
    @IBAction func repeatPasswordTextFieldEndEditing(sender:UITextField) {
        self.repeatPassword.transform = CGAffineTransformMakeTranslation(0, 0)
        self.loginTextField.transform = CGAffineTransformMakeTranslation(0, 0)
        self.passwordTextField.transform = CGAffineTransformMakeTranslation(0, 0)
    }
    
    @IBAction func tapOnView() {
        self.repeatPassword.resignFirstResponder()
        self.loginTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        if countElements(self.loginTextField.text!) > 4 && countElements(self.passwordTextField.text!) > 4 && self.passwordTextField.text == self.repeatPassword.text {
            
        }
    }
}

