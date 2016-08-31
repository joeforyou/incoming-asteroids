//
//  MainViewController.swift
//  Doomed
//
//  Created by Joseph Kleinschmidt on 8/23/16.
//  Copyright © 2016 Joseph Kleinschmidt. All rights reserved.

import UIKit

import Alamofire

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let currentDate = NSDate()
    var asteroids = [Asteroid]()
    var units = "metric"
    var min: Double = 0.0
    
    @IBOutlet weak var setDateButton: UIButton!
    @IBOutlet weak var selectDateButton: UIButton!
    
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBAction func segControl(sender: UISegmentedControl) {
        switch segmented.selectedSegmentIndex{
        case 0:
            self.units = "metric"
        case 1:
            self.units = "imperial"
        case 2:
            self.units = "stratus"
        default:
            self.units = "metric"
        }
        self.asteroidTableView.reloadData()
    }

    @IBOutlet weak var asteroidTableView: UITableView!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var datePickerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var numAsteroidsApproachingLabel: UILabel!
    
    @IBAction func setButtonPressed(sender: UIButton) {
        if self.datePicker.date != currentDate {
            self.asteroids = [Asteroid]()
            requestDataFromNASA(self.datePicker.date)
        }
        self.datePickerBottomConstraint.constant = -300
        self.view.setNeedsLayout()
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            self.view.layoutIfNeeded()
            }, completion: { _ in
                print("picker view is hiding")
        })
    }
    @IBAction func selectDateButtonPressed(sender: UIButton) {
        self.datePickerBottomConstraint.constant = 0
        self.view.setNeedsLayout()
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            self.view.layoutIfNeeded()
            }, completion: { _ in
                print("picker view is showing")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectDateButton.titleLabel?.font = UIFont(name: "GillSans", size: 15.0)
        setDateButton.titleLabel?.font = UIFont(name: "GillSans", size: 15.0)
        requestDataFromNASA(currentDate)
    }
    
    

    func requestDataFromNASA (date: NSDate) {
        
        // Display current date/time
        
        let fd = NSDateFormatter()
        fd.dateFormat = "MMMM d, yyyy"
        let selectedDate = fd.stringFromDate(date)
        self.currentDateLabel.text = selectedDate
        self.currentDateLabel.font = UIFont(name: "GillSans", size: 30.0)
        
        // Date for API call
        
        fd.dateFormat = "yyyy-MM-dd"
        let dayOne = fd.stringFromDate(date)
        
        // Make API call
        
        Alamofire.request(.GET, "https://api.nasa.gov/neo/rest/v1/feed?start_date=\(dayOne)&end_date=\(dayOne)&api_key=bSalE9iQblRBFDZBuUQGB2FqerlDcWT2ClqDhQWx")
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    //                    print("JSON: \(JSON)")
                    print("Near earth objects \(JSON["element_count"]!!)")
                    //                    let asteroidArr = JSON["near_earth_objects"]!![apiEndDate]!! as! Array<AnyObject>
                    let asteroidArr = JSON["near_earth_objects"]!![dayOne]!! as! Array<AnyObject>
                    
//                    print(asteroidArr)
                    
                    for asteroid in asteroidArr {
                        let newAsteroid = Asteroid.init(name: asteroid["name"]!! as! String, absolute_magnitude: asteroid["absolute_magnitude_h"]!! as! Double, estimated_diameter_ft: asteroid["estimated_diameter"]!!["feet"]!!["estimated_diameter_max"]!! as! Double, estimated_diameter_m: asteroid["estimated_diameter"]!!["meters"]!!["estimated_diameter_max"]!! as! Double,  is_potentially_hazardous: asteroid["is_potentially_hazardous_asteroid"]!! as! Bool,  link: asteroid["nasa_jpl_url"]!! as! String)
                        
                        // print("close approach data: \(asteroid["close_approach_data"]!!)")
                        
                        let approachData = asteroid["close_approach_data"]!! as! Array<AnyObject>
                        for item in approachData {
                            newAsteroid?.close_approach_date = item["close_approach_date"]!! as! String
                            
                            let dm = item["miss_distance"]!!["miles"]!! as! String
                            newAsteroid?.miss_distance_miles = dm
                            
                            let dk = item["miss_distance"]!!["kilometers"]!! as! String
                            newAsteroid?.miss_distance_km = dk
                            print(newAsteroid?.miss_distance_km)
                            
                            let vmh = item["relative_velocity"]!!["miles_per_hour"]!! as! String
                            newAsteroid?.velocity_miles_per_hour = vmh
                            
                            let vkh = item["relative_velocity"]!!["kilometers_per_hour"]!! as! String
                            newAsteroid?.velocity_km_per_hour = vkh
                        }
                        self.asteroids.append(newAsteroid!)
                        
                    }
                    
                    self.min = Double(self.asteroids[0].miss_distance_km)!
                    
                    for i in 0 ..< self.asteroids.count - 1 {
                        if (Double(self.asteroids[i].miss_distance_km) < self.min && self.asteroids[i].miss_distance_km != ""){
                            self.min = Double(self.asteroids[i].miss_distance_km)!
                        }
                    }
                    
                    print(self.min)
                    self.numAsteroidsApproachingLabel.text = "INCOMING ASTEROIDS: \(String(self.asteroids.count))"
                    self.numAsteroidsApproachingLabel.font = UIFont(name: "Courier-Bold", size: 20.0)
                    self.asteroidTableView.reloadData()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func suffixNumber(number:NSNumber) -> NSString {
        
        var num:Double = number.doubleValue;
        let sign = ((num < 0) ? "-" : "" );
        
        num = fabs(num);
        
        if (num < 1000.0){
            return "\(sign)\(num)";
        }
        
        let exp:Int = Int(log10(num) / 3.0 ); //log10(1000));
        
        let units:[String] = [" thousand"," million"," billion"," trillion","P","E"];
        
        let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10;
        
        return "\(sign)\(roundedNum)\(units[exp-1])";
    }
    
    // MARK: - TABLE VIEW functions
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "AsteroidCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AsteroidTableViewCell
        // Fetches the appropriate vehicle for the data source layout.
        if self.asteroids.count > 0 {
            let asteroid = asteroids[indexPath.row]
        
            let b = asteroid.absolute_magnitude
        
            switch b {
                case let b where b <= 3:
                    cell.brightnessScaleTextLabel.text = "🔆🔆🔆🔆🔆🔆🔆🔆🔆🔆"
                case let b where 3 < b && b <= 6:
                    cell.brightnessScaleTextLabel.text = "🔆🔆🔆🔆🔆🔆🔆🔆🔆"
                case let b where 6 < b && b <= 9:
                    cell.brightnessScaleTextLabel.text = "🔆🔆🔆🔆🔆🔆🔆🔆"
                case let b where 9 < b && b <= 12:
                    cell.brightnessScaleTextLabel.text = "🔆🔆🔆🔆🔆🔆🔆"
                case let b where 12 < b && b <= 15:
                    cell.brightnessScaleTextLabel.text = "🔆🔆🔆🔆🔆🔆"
                case let b where 15 < b && b <= 18:
                    cell.brightnessScaleTextLabel.text = "🔆🔆🔆🔆🔆"
                case let b where 18 < b && b <= 21:
                    cell.brightnessScaleTextLabel.text = "🔆🔆🔆🔆"
                case let b where 21 < b && b <= 24:
                    cell.brightnessScaleTextLabel.text = "🔆🔆🔆🔆"
                case let b where 24 < b && b <= 27:
                    cell.brightnessScaleTextLabel.text = "🔆🔆🔆"
                case let b where 27 < b && b <= 30:
                    cell.brightnessScaleTextLabel.text = "🔆🔆🔆"
                case let b where 30 < b && b <= 31:
                    cell.brightnessScaleTextLabel.text = "🔆🔆"
                case let b where 31 < b && b <= 32:
                    cell.brightnessScaleTextLabel.text = "🔆"
                default:
                    cell.brightnessScaleTextLabel.text = ""
            }
        
            cell.nasaLink = asteroid.link
        
            cell.asteroidNameButton.setTitle(asteroid.name, forState: UIControlState.Normal)
            cell.asteroidNameButton.titleLabel!.font = UIFont(name: "GillSans-Bold", size: 20.0)
        
            let date = asteroid.close_approach_date as NSString
            let choppedDate = date.substringWithRange(NSRange(location: 5, length: 5))
            cell.dateLabel.text = "Approaching on: \(choppedDate)"
            cell.dateLabel.font = UIFont(name: "GillSans-Italic", size: 14.0)
        
            if Double(asteroid.miss_distance_km) == self.min {
                cell.hazardStampLabel.hidden = false
                cell.hazardTextLabel.text = "CLOSEST TO 🌎"
                cell.blueBar.hidden = true
            }
            else {
        
                if asteroid.is_potentially_hazardous == true {
                    cell.hazardStampLabel.hidden = false
                    cell.hazardTextLabel.text = "HAZARDOUS"
                    cell.blueBar.hidden = true
                }
                else {
                    cell.hazardStampLabel.hidden = true
                    cell.blueBar.hidden = false
                }
            }
        

        
            if (self.units == "metric") {
                let diameter = asteroid.estimated_diameter_m
                let roundedD = Int(round(diameter))
                cell.diameterLabel.text = "\(String(roundedD)) meters wide"
                cell.diameterLabel.font = UIFont(name: "GillSans", size: 23.0)
            
                let velocity = (asteroid.velocity_km_per_hour as NSString).doubleValue
                let roundedV = Int(round(velocity))
            
                cell.velocityLabel.text = "\(roundedV) km/hour"
                cell.velocityLabel.font = UIFont(name: "GillSans", size: 23.0)
            
                let num = Double(asteroid.miss_distance_km)! as NSNumber
                let readable = suffixNumber(num)
            
                cell.missDistanceValLabel.text = "\(readable) kilometers"
                cell.missDistanceValLabel.font = UIFont(name: "GillSans", size: 18.0)
            
                cell.missDistanceLabel.font = UIFont(name: "GillSans", size: 18.0)
            }
            else if (self.units == "imperial") {
                let diameter = asteroid.estimated_diameter_ft
                let roundedD = Int(round(diameter))
                cell.diameterLabel.text = "\(String(roundedD)) feet wide"
                cell.diameterLabel.font = UIFont(name: "GillSans", size: 23.0)
            
                let velocity = (asteroid.velocity_miles_per_hour as NSString).doubleValue
                let roundedV = Int(round(velocity))
            
                cell.velocityLabel.text = "\(roundedV) mi/hour"
                cell.velocityLabel.font = UIFont(name: "GillSans", size: 23.0)
            
                let num = Double(asteroid.miss_distance_miles)! as NSNumber
                let readable = suffixNumber(num)
            
                cell.missDistanceValLabel.text = "\(readable) miles"
                cell.missDistanceValLabel.font = UIFont(name: "GillSans", size: 18.0)
            
                cell.missDistanceLabel.font = UIFont(name: "GillSans", size: 18.0)
            }
            else if (self.units == "stratus") {
                let stratusM = 4.85648
                let diameter = asteroid.estimated_diameter_m / stratusM
                let roundedD = Int(round(diameter))
                cell.diameterLabel.text = "\(String(roundedD)) Stratuses wide"
                cell.diameterLabel.font = UIFont(name: "GillSans", size: 23.0)
            
                let velocity = (asteroid.velocity_miles_per_hour as NSString).doubleValue
                let roundedV = Int(round(velocity))
            
                cell.velocityLabel.text = "\(roundedV) mi/hour"
                cell.velocityLabel.font = UIFont(name: "GillSans", size: 23.0)
            
                let stratusInK = 0.00485648
                let num = Double(asteroid.miss_distance_km)! / stratusInK as NSNumber
                let readable = suffixNumber(num)
                cell.missDistanceValLabel.text = "\(readable) Stratuses"
                cell.missDistanceValLabel.font = UIFont(name: "GillSans", size: 18.0)
            
                cell.missDistanceLabel.font = UIFont(name: "GillSans", size: 18.0)
            }
        }
        else{
            cell.textLabel?.text = "No asteroids approaching. Lucky you."
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return asteroids.count
    }
}
