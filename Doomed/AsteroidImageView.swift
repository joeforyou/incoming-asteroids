//
//  AsteroidImageView.swift
//  Doomed
//
//  Created by Joseph Kleinschmidt on 8/24/16.
//  Copyright © 2016 Joseph Kleinschmidt. All rights reserved.
//

import UIKit

@IBDesignable

class AsteroidImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
