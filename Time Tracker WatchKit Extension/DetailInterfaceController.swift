//
//  DetailInterfaceController.swift
//  Time Tracker WatchKit Extension
//
//  Created by muhammad Awais on 11/16/19.
//  Copyright © 2019 muhammad Awais. All rights reserved.
//

import WatchKit
import Foundation


class DetailInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var clockInLabel: WKInterfaceLabel!
    
    @IBOutlet weak var clockOutLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        if let dates = context as? [Date] {
            
            let clockIn = dates[0]
            let clockOut = dates[1]
            
            var formatter = DateFormatter()
            formatter.dateFormat = "MMM d h:mma"

            clockInLabel.setText(formatter.string(from: clockIn))
            clockOutLabel.setText(formatter.string(from: clockOut))
        }
    }

}
