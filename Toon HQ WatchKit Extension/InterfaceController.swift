//
//  InterfaceController.swift
//  Toon HQ WatchKit Extension
//
//  Created by Anthony Castelli on 11/18/14.
//  Copyright (c) 2014 Anthony Castelli. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    // IB Outlets
    @IBOutlet var invasionTable: WKInterfaceTable!
    
    // Regular variables
    var invasions: Array<Dictionary<String, AnyObject>> = []
    
    override init(context: AnyObject?) {
        // Initialize variables here.
        super.init(context: context)
        
        // Configure interface objects here.
        NSLog("%@ init", self)
        
        // Define the timer as a constant as we won't be changing this
        // 15 seconds might be too fast or too slow... idk
        let timer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: "fetchInvasions", userInfo: nil, repeats: true)
        timer.fire()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ will activate", self)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
    }
    
    // MARK: TableView Data
    
    func fetchInvasion() {
        
    }

}
