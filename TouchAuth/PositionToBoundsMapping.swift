//
//  PositionToBoundsMapping.swift
//  TouchAuth
//
//  Created by Прибыткова Зоя on 28.06.14.
//  Copyright (c) 2014 Прибыткова Зоя. All rights reserved.
//

import UIKit

class PositionToBoundsMapping: NSObject, UIDynamicItem {
    
    var bounds: CGRect
    {
    get {
        return self.target.bounds
    }
    }
    
    var center: CGPoint {
    get {
        return CGPointMake(self.target.bounds.size.width, self.target.bounds.size.height)
    }
    set {
        self.target.bounds = CGRectMake(0, 0, newValue.x, newValue.y)
    }
    }
    
    var transform: CGAffineTransform {
    get {
        return self.target.transform
    }
    set {
        self.target.transform = newValue
    }
    }
    
    var target: UIButton
    
    init (target: UIButton)
    {
        self.target = target
        super.init()
    }
    
   
}
