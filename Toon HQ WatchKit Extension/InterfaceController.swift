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
    
    func fetchInvasions() {
        // Retrieve our JSON data
        request(.GET, "http://toonhq.org/api/v1/invasion/").responseJSON { (request, response, json, error) in
            // Typecasting we must.
            // The main response is formatted in a dictionary, so we need to pull our dictionaries
            // and grab the data from the invaisons
            if let jsonResponse = json as? Dictionary<String, AnyObject> {
                
                // Grab the data from the invasions dictionary
                if let jsonResult = jsonResponse["invasions"] as? Array<Dictionary<String, AnyObject>> {
                    
                    // Set it to our variable
                    self.invasions = jsonResult
                    
                    // Load our data into the table
                    self.loadTableData()
                    
                    // NOTE: We are in a nested closure therefore we have to call self
                }
            }
        }
    }
    
    // MARK: TableView Data
    
    func loadTableData() {
        // Set the number of rows
        invasionTable.setNumberOfRows(invasions.count, withRowType: "InvasionList")
        
        // Loop over everything and set our data
        for (index, invasion) in enumerate(invasions) {
            
            // Get our row at the specified index
            let row = invasionTable.rowControllerAtIndex(index) as InvasionList
            
            // Grab our suit (or cog) name
            var cog = invasion["cog"] as String!
            
            // Set the cog name to the row
            row.suitName.setText(cog)
            
            // Yesman's images are formatted weird for some reason so we have to manually fix it
            if cog == "Yesman" {
                cog = "Yes Man"
            }
            
            // Make the string lowercase, strip any spaces we have and replace them with underscores
            let formattedCog = cog.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "_", options: nil, range: nil)
            let address = "http://toonhq.org/static/2.03/img/cogs/\(formattedCog).png"
            
            // Lets do this in the background so we don't freeze the mainThread
            let request: NSURLRequest = NSURLRequest(URL: NSURL(string: address)!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                // Make sure we don't have an error
                if error == nil {
                    if let suitIcon = UIImage(data: data) {
                        row.suitIcon.setImage(suitIcon)
                    }
                } else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        println("Tapped row: \(rowIndex) -- Invasion Info: \(invasions[rowIndex])")
        // TODO: Show details for the current invasion
    }

}
