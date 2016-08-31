//
//  Asteroid.swift
//  Doomed
//
//  Created by Joseph Kleinschmidt on 8/23/16.
//  Copyright © 2016 Joseph Kleinschmidt. All rights reserved.
//

import Foundation

class Asteroid {
    // MARK Properties
    var name: String
    var absolute_magnitude: Double
    var estimated_diameter_ft: Double
    var estimated_diameter_m: Double
    var is_potentially_hazardous: Bool
    var link: String
    var close_approach_date: String
    var miss_distance_miles: String
    var miss_distance_km: String
    var velocity_miles_per_hour: String
    var velocity_km_per_hour: String
    var orbiting_body: String
    
    init?(name: String, absolute_magnitude: Double, estimated_diameter_ft: Double, estimated_diameter_m: Double, is_potentially_hazardous: Bool, link: String) {
        self.name = name
        self.absolute_magnitude = absolute_magnitude
        self.estimated_diameter_ft = estimated_diameter_ft
        self.estimated_diameter_m = estimated_diameter_m
        self.is_potentially_hazardous = is_potentially_hazardous
        self.link = link
        self.close_approach_date = ""
        self.miss_distance_miles = ""
        self.miss_distance_km = ""
        self.velocity_miles_per_hour = ""
        self.velocity_km_per_hour = ""
        self.orbiting_body = ""
    }
}