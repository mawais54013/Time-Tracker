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
            self.topLabel.setText("Today: \(totalTimeWorkedAsString())")
            middleLabel.setText("0s")
            button.setTitle("Clock-Out")
            button.setBackgroundColor(UIColor.red)
        }
        else {
//            ui for someone is clocked out
            topLabel.setHidden(true)
            button.setTitle("Clock-In")
            button.setBackgroundColor(UIColor.green)
            
            middleLabel.setText("Today\n\(totalTimeWorkedAsString())")
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
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date {
                let timeInterval = Int(Date().timeIntervalSince(clockedInDate))
                
                let hours = timeInterval / 3600
                let minutes = (timeInterval % 3600) / 60
                let seconds = timeInterval % 60
                
                var currentClockedInString = ""
                
                if hours != 0 {
                    currentClockedInString += "\(hours)h "
                }
                if minutes != 0 || hours != 0 {
                    currentClockedInString += " \(minutes)m "
                }
                
                currentClockedInString += "\(seconds)s"
                
                self.middleLabel.setText(currentClockedInString)
                
                self.topLabel.setText("Today: \(self.totalTimeWorkedAsString())")
            }
        }
    }
    
    func clockOut() {
        clockedIn = false
        
        if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date {
            if var clockIns = UserDefaults.standard.array(forKey: "clockIns") as? [Date] {
                clockIns.insert(clockedInDate, at: 0)
                UserDefaults.standard.set(clockIns, forKey: "clockIns")
            }
            else
            {
                UserDefaults.standard.set([clockedInDate], forKey: "clockIns")
            }
            
            if var clockOuts = UserDefaults.standard.array(forKey: "clockOuts") as? [Date] {
               clockOuts.insert(Date(), at: 0)
               UserDefaults.standard.set(clockOuts, forKey: "clockOuts")
           }
           else
           {
               UserDefaults.standard.set([Date()], forKey: "clockOuts")
           }
            
            UserDefaults.standard.set(nil, forKey: "clockedIn")
        }
        
        UserDefaults.standard.synchronize()
        
    }
    
    func totalClockedTime() -> Int {
        if var clockIns = UserDefaults.standard.array(forKey: "clockIns") as? [Date] {
            if var clockOuts = UserDefaults.standard.array(forKey: "clockOuts") as? [Date] {
                
                var seconds = 0
                for index in 0..<clockIns.count {
                    let currentSeconds = Int(clockOuts[index].timeIntervalSince(clockIns[index]))
                    
                    seconds += currentSeconds
                }
                return seconds
            }
        }
        return 0
    }
    
    func totalTimeWorkedAsString() -> String {
        
        var currentClockInSeconds = 0
        
        if let clockedInDate = UserDefaults.standard.value(forKey: "clockedIn") as? Date {
            currentClockInSeconds = Int(Date().timeIntervalSince(clockedInDate))
        }
            
        let totalTimeInterval = currentClockInSeconds + self.totalClockedTime()
        let totalHours = totalTimeInterval / 3600
        let totalMinutes = (totalTimeInterval % 3600) / 60
        
        return "\(totalHours)h \(totalMinutes)m"
        
    }
    
    @IBAction func resetAllTapped() {
        UserDefaults.standard.set(nil, forKey: "clockedIn")
        
        UserDefaults.standard.set(nil, forKey: "clockIns")
        UserDefaults.standard.set(nil, forKey: "clockOuts")
        
        UserDefaults.standard.synchronize()
        
        updateUI(clockedIn: false)
    }
    
    @IBAction func historyTapped() {
        pushController(withName: "TimeTableController", context: nil)
    }
    
}
