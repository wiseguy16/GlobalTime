//
//  AllZonesTableViewController.swift
//  GlobalTime
//
//  Created by Gregory Weiss on 8/22/16.
//  Copyright © 2016 Gregory Weiss. All rights reserved.
//

import UIKit

class AllZonesTableViewController: UITableViewController {
    
    var delegate: PickZoneViewControllerDelegate?
    
    var zones = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
       // zones = NSTimeZone.knownTimeZoneNames

       
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
        return zones.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllZoneCell", for: indexPath)

        // Configure the cell...
      //  let aZone = zones[indexPath.row]
        let zoneStringTempArray = zones[indexPath.row].components(separatedBy: "/")
        cell.textLabel?.text = zoneStringTempArray[1]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let theIndex: Int = indexPath.row
        let theZone = zones[indexPath.row]
        delegate!.zoneWasChosen(theZone, theIndex: theIndex)
        dismiss(animated: true, completion: nil)
    }
   
}
