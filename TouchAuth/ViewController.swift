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
    @IBOutlet var signInButton: UIButton
    var animator: UIDynamicAnimator?
    var buttonBounds: CGRect?
    var registrationVC: RegistrationViewController!
    let protectionSpace = AppProtectionSpace.sharedInstance()
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registrationView.alpha = 0;
        self.signInButton.alpha = 0;
        buttonBounds = tapMeButton.bounds
        self.backgroundImageView.addMotionEffect(self.motionEffect())
        let account:NSURLCredentialStorage! = NSURLCredentialStorage.sharedCredentialStorage();
        if account.defaultCredentialForProtectionSpace(self.protectionSpace.space) == nil {
            self.tapMeButton.setImage(UIImage(named:"join"), forState: UIControlState.Normal)
            self.tapMeButton.tag = 1;
        } else {
            self.tapMeButton.setImage(UIImage(named:"signin"), forState:UIControlState.Normal)
            self.tapMeButton.tag = 2;
        }
        
        let blur = UIVisualEffectView(effect:UIBlurEffect(style:.Light)) as UIVisualEffectView
        blur.frame = CGRectMake(-30, -15, 380, 670);
        self.backgroundImageView.addSubview(blur)
    }
    
    func motionEffect() -> UIMotionEffectGroup
    {
        var xAxis :UIInterpolatingMotionEffect! = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.TiltAlongHorizontalAxis)
        xAxis.minimumRelativeValue = -30.0
        xAxis.maximumRelativeValue = 30.0
        
        var yAxis :UIInterpolatingMotionEffect! = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
        yAxis.minimumRelativeValue = -15.0;
        yAxis.maximumRelativeValue = 15.0;
        
        var foregroundViewMotionEffect: UIMotionEffectGroup = UIMotionEffectGroup()
        foregroundViewMotionEffect.motionEffects = [xAxis, yAxis]
        
        return foregroundViewMotionEffect
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
    
    @IBAction func signInTouch(sender:UIButton) {
        let myCredential = NSURLCredential(user:self.registrationVC.loginTextField.text, password:self.registrationVC.passwordTextField.text, persistence:NSURLCredentialPersistence.Synchronizable)
        NSURLCredentialStorage.sharedCredentialStorage().setDefaultCredential(myCredential, forProtectionSpace: self.protectionSpace.space)
    }
    
    func processingRegistration() {
        UIView.animateWithDuration(1.0, animations: {
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
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?)
    {
        if segue?.identifier == "myEmbedFieldSegue" {
            self.registrationVC = segue?.destinationViewController as? RegistrationViewController
            self.registrationVC.source = self
        }
    }
    
    func validateTextField() {
        if countElements(self.registrationVC.loginTextField.text!) > 3 && countElements(self.registrationVC.passwordTextField.text!) > 3 && self.registrationVC.passwordTextField.text == self.registrationVC.repeatPassword.text {
            UIView.animateWithDuration(1.0, animations: {
                self.signInButton.alpha = 1;
                })
        }
    }
    
    
    
    
}

class RegistrationViewController:UIViewController, UITextFieldDelegate {
    
    @IBOutlet var repeatPassword:       UITextField
    @IBOutlet var loginTextField:       UITextField
    @IBOutlet var passwordTextField:    UITextField
    var source: ViewController!
    
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
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if textField == self.loginTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            self.repeatPassword.becomeFirstResponder()
        } else {
            self.repeatPassword.resignFirstResponder()
        }
        
        return true;
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        self.source.validateTextField()
    }

}
    
    


