//
//  HazardStampView.swift
//  Doomed
//
//  Created by Joseph Kleinschmidt on 8/24/16.
//  Copyright © 2016 Joseph Kleinschmidt. All rights reserved.
//

import UIKit

@IBDesignable

class HazardStampView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
}
