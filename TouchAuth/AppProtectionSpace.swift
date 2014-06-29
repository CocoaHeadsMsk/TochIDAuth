//
//  AppProtectionSpace.swift
//  TouchAuth
//
//  Created by Прибыткова Зоя on 29.06.14.
//  Copyright (c) 2014 Прибыткова Зоя. All rights reserved.
//

import UIKit

class AppProtectionSpace: NSObject {
    
    var space: NSURLProtectionSpace?
    
    class func sharedInstance() -> AppProtectionSpace! {
        struct Static {
            static var instance: AppProtectionSpace? = nil
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = self()
            Static.instance!.space = NSURLProtectionSpace(host:"round.me", port:0, `protocol`:"http", realm:nil, authenticationMethod:NSURLAuthenticationMethodDefault)
        }
        
        return Static.instance!
    }
    
    @required init() {
        super.init()
        
    }
   
}