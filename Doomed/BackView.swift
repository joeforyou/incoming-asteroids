//
//  BackView.swift
//  Doomed
//
//  Created by Joseph Kleinschmidt on 8/25/16.
//  Copyright © 2016 Joseph Kleinschmidt. All rights reserved.
//

import UIKit

@IBDesignable

class BackView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
}
