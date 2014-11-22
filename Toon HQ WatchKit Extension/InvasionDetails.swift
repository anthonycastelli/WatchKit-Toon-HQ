//
//  InvasionDetails.swift
//  Toon HQ
//
//  Created by Anthony Castelli on 11/18/14.
//  Copyright (c) 2014 Anthony Castelli. All rights reserved.
//

import WatchKit

class InvasionDetails: WKInterfaceController {
    
    // Lets setup our outlets again
    @IBOutlet weak var suitIcon: WKInterfaceImage!
    @IBOutlet weak var suitName: WKInterfaceLabel!
    @IBOutlet weak var shardName: WKInterfaceLabel!
    @IBOutlet weak var timeLeft: WKInterfaceTimer!
    @IBOutlet weak var megaInvasion: WKInterfaceLabel!
    @IBOutlet weak var suitsPerMinute: WKInterfaceLabel!
    
    // We need this later
    let invasionInfo: Dictionary<String, AnyObject> = Dictionary()
    
    override init(context: AnyObject?) {
        // Initialize variables here.
        super.init(context: context)
        
        // Configure interface objects here.
        if let invasion = context as? Dictionary<String, AnyObject> {
            invasionInfo = invasion
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        readInvaisonData()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // Read our invasion info
    func readInvaisonData() {
        // Lets pull out our important info
        var cog = invasionInfo["cog"] as String!
        let district = invasionInfo["district"] as String!
        let totalAmount = invasionInfo["total"] as Int!
        let defeated = invasionInfo["defeated"] as Int!
        let defeatRate = invasionInfo["defeat_rate"] as Float!
        
        // Give the controller a title
        setTitle(cog)
        
        // Yesman's images are formatted weird for some reason so we have to manually fix it
        if cog == "Yesman" {
            cog = "Yes Man"
        }
        
        // Set all our data
        if let address = createFormattedImageAddress(cog) {
            let request: NSURLRequest = NSURLRequest(URL: NSURL(string: address)!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                // Make sure we don't have an error
                if error == nil {
                    if let suitIcon = UIImage(data: data) {
                        self.suitIcon.setImage(suitIcon)
                    }
                } else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
        
        suitName.setText(cog)
        shardName.setText(district)
        suitsPerMinute.setText(String(format: "Approx. %.f cog/min", round(defeatRate * 60)))

        // Check if we have a mega invasion
        // It appears a million cogs is a mega invasion
        if totalAmount >= 1000000 && defeated == 0 {
            timeLeft.setHidden(true)
            megaInvasion.setHidden(false)
        } else {
            let time: Float = round(Float(totalAmount) * defeatRate - Float(defeated) * defeatRate)
            let date = NSDate(timeInterval: NSTimeInterval(time), sinceDate: NSDate())
            timeLeft.setDate(date)
            timeLeft.start()
        }
    }
    
    // MARK: Helpers
    
    func createFormattedImageAddress(suit: String?) -> String? {
        
        // Typecast to ensure safer code
        if let cog = suit {
            
            // Create our lowercase string
            var formattedCog = cog.lowercaseString
            
            // Add any characters that might need to be stripped from a string
            let charactersToStrip = ["-", " "]
            
            // Loop over everything and remove it
            for character in charactersToStrip {
                formattedCog = formattedCog.stringByReplacingOccurrencesOfString(character, withString: "_", options: nil, range: nil)
            }
            
            // URL encode it all
            formattedCog = formattedCog.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
            
            // This makes me cry right here...
            formattedCog = formattedCog.stringByReplacingOccurrencesOfString("%03", withString: "", options: nil, range: nil)
            
            // Check and see if we are a skelecog
            if formattedCog.contains("skelecog") {
                formattedCog = "skelecog"
            }
            
            // Put it all together
            let address = "http://toonhq.org/static/2.03/img/cogs/\(formattedCog).png"
            
            // BOOM! Return the value!
            return address
        }
        
        return nil
    }
    
}
