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
    
    override init(context: AnyObject?) {
        // Initialize variables here.
        super.init(context: context)
        
        // Configure interface objects here.
        NSLog("%@ init", self)
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

}
