//
//  AsteroidTableViewCell.swift
//  Doomed
//
//  Created by Joseph Kleinschmidt on 8/23/16.
//  Copyright © 2016 Joseph Kleinschmidt. All rights reserved.
//

import UIKit

class AsteroidTableViewCell: UITableViewCell {
    

    @IBOutlet weak var asteroidCellView: AsteroidCellView!

    @IBOutlet weak var brightnessScaleTextLabel: UILabel!
    
    var nasaLink: String?
    // Asteroid info top line
    @IBOutlet weak var asteroidNameButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    // Asteroid specs left side
    @IBOutlet weak var diameterLabel: UILabel!
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var missDistanceLabel: UILabel!
    @IBOutlet weak var missDistanceValLabel: UILabel!
    // Blue separator
    @IBOutlet weak var blueBar: BlueBarView!
    // Hazardous label
    @IBOutlet weak var hazardStampLabel: HazardStampView!
    
    @IBOutlet weak var hazardTextLabel: UILabel!


    // Pressed the button
    @IBAction func nameButtonPressed(sender: UIButton) {
        let url = NSURL(string: self.nasaLink!)
        UIApplication.sharedApplication().openURL(url!)
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
