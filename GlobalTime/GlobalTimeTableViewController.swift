//
//  GlobalTimeTableViewController.swift
//  GlobalTime
//
//  Created by Gregory Weiss on 8/22/16.
//  Copyright © 2016 Gregory Weiss. All rights reserved.
//

import UIKit
import Foundation

protocol PickZoneViewControllerDelegate
{
    func zoneWasChosen(_ zonePicked: String, theIndex: Int)
}

class GlobalTimeTableViewController: UITableViewController, PickZoneViewControllerDelegate, UIPopoverPresentationControllerDelegate
{
    
   // var clockView: ClockView!
    let timeZoneArray = NSTimeZone.knownTimeZoneNames
    var visibleTimeZones = [String]()
    var remainingTimeZones = [String]()
    
    
    


    override func viewDidLoad()
    {
        super.viewDidLoad()
        let allTimeZones = timeZoneArray
        remainingTimeZones = allTimeZones
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return visibleTimeZones.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SmallClockCell", for: indexPath) as! SmallClockCell

                
        // Configure the cell...
        let aClockView = ClockView(frame: cell.smallClockView.frame)
        aClockView.timezone = NSTimeZone(name: visibleTimeZones[indexPath.row])
        
        cell.timeZoneAreaLabel.text = visibleTimeZones[indexPath.row]
        cell.smallClockView = aClockView
        return cell
    }
 
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "AllZonesSegue"
        {
            let allZonesVC = segue.destination as! AllZonesTableViewController
            allZonesVC.delegate = self
            allZonesVC.zones = remainingTimeZones
            allZonesVC.popoverPresentationController!.delegate = self
//          allZonesVC.modalPresentationStyle =
            //popoverPresentationController
            let contentHeigt = (44.0 * Double(remainingTimeZones.count))
            allZonesVC.preferredContentSize = CGSize(width: 100.0, height: contentHeigt)
            
        }
        if segue.identifier == "BigClockSegue"
        {
            let bigVC = segue.destination as! BigClockViewController
            let indexPath: NSIndexPath = tableView.indexPathForSelectedRow!
            let selectedClock = visibleTimeZones[(indexPath.row)]
            bigVC.aClockView =  selectedClock
    
        }
        
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController)
    {
        //do som stuff from the popover
    }
    
    func zoneWasChosen(_ zonePicked: String, theIndex: Int)
    {
       // let newZone = zonePicked
        visibleTimeZones.append(zonePicked)
        remainingTimeZones.remove(at: theIndex)
        tableView.reloadData()
        
    }


}
