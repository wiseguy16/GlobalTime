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
   
    var visibleTimeZones = [String]()
    var remainingTimeZones = [String]()
    
    
    


    override func viewDidLoad()
    {
        super.viewDidLoad()
         let timeZoneArray = NSTimeZone.knownTimeZoneNames
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
       // let aClockView = ClockView(frame: cell.smallClockView.frame)
        
        let timeZoneName = visibleTimeZones[indexPath.row]
        let possibleTimeZone = NSTimeZone(name: timeZoneName)
        if let thisTimeZone = possibleTimeZone
        {
            cell.smallClockView.timezone = thisTimeZone
        }
        
        let tempStringArray = timeZoneName.components(separatedBy: "/")
        
       // aClockView.timezone = NSTimeZone(name: visibleTimeZones[indexPath.row])
       // let tempStringArray = visibleTimeZones[indexPath.row].components(separatedBy: "/")
        
        cell.timeZoneAreaLabel.text = tempStringArray[1]
      //  cell.smallClockView = aClockView
        return cell
    }
 
 
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "AllZonesSegue"
        {
            let allZonesVC = segue.destination as! AllZonesTableViewController
            allZonesVC.delegate = self
            allZonesVC.zones = remainingTimeZones
            allZonesVC.popoverPresentationController!.delegate = self
            let contentHeigt = (44.0 * Double(remainingTimeZones.count))
            allZonesVC.preferredContentSize = CGSize(width: 140.0, height: contentHeigt)
            
        }
        if segue.identifier == "BigClockSegue"
        {
            let bigVC = segue.destination as! BigClockViewController
            let indexPath: IndexPath = tableView.indexPathForSelectedRow!
            
            let timeZoneName2 = visibleTimeZones[indexPath.row]
            let possibleTimeZone2 = NSTimeZone(name: timeZoneName2)
            if let thisTimeZone2 = possibleTimeZone2
            {
                bigVC.temptimeZone = thisTimeZone2
                
            }
            
            
           // bigVC.theBigClock2.timezone = possibleTimeZone2

            
            
            //let selectedClock = visibleTimeZones[(indexPath.row)]
            //bigVC.theBigClock2.timezone =  selectedClock
    
        }
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .none
    }
    
 //   func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController)
 //   {
 //       //do som stuff from the popover
 //   }
    
    func zoneWasChosen(_ zonePicked: String, theIndex: Int)
    {
        dismiss(animated: true, completion: nil)
        visibleTimeZones.append(zonePicked)
        remainingTimeZones.remove(at: theIndex)
        tableView.reloadData()
        
    }


}
