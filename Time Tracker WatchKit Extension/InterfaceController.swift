//
//  InterfaceController.swift
//  Time Tracker WatchKit Extension
//
//  Created by muhammad Awais on 11/2/19.
//  Copyright © 2019 muhammad Awais. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var topLabel: WKInterfaceLabel!
    @IBOutlet weak var middleLabel: WKInterfaceLabel!
    @IBOutlet weak var button: WKInterfaceButton!
    
    var clockedIn = false
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        updateUI(clockedIn: clockedIn)
    }
    
    func updateUI(clockedIn:Bool) {
        if clockedIn {
//            The ui for someone is clocked in
            topLabel.setHidden(false)
            middleLabel.setText("5m 22s")
            button.setTitle("Clocked-Out")
            button.setBackgroundColor(UIColor.red)
        }
        else {
//            ui for someone is clocked out
            topLabel.setHidden(true)
            middleLabel.setText("Today\n3h 44m")
            button.setTitle("Clocked-In")
            button.setBackgroundColor(UIColor.green)
        }
    }
    
    @IBAction func clockInOutTapped() {
        if clockedIn {
            clockOut()
        }
        else
        {
            clockIn()
        }
        updateUI(clockedIn: clockedIn)
    }
    
    func clockIn() {
        clockedIn = true
        
        UserDefaults.standard.set(Date(), forKey: "clockedIn")
        UserDefaults.standard.synchronize()
    }
    
    func clockOut() {
        clockedIn = false
        
        if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date {
            print(clockedInDate)
        }
    }
}
