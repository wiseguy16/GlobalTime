//
//  BigClockViewController.swift
//  GlobalTime
//
//  Created by Gregory Weiss on 8/22/16.
//  Copyright © 2016 Gregory Weiss. All rights reserved.
//

import UIKit

class BigClockViewController: UIViewController
{
    var aClockView = String()
    var theBigClock: BigClock!
    

    @IBOutlet weak var bigClockView: BigClock!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        theBigClock = BigClock(frame: CGRect(x: view.center.x - 100, y: view.center.y - 100, width: 200, height: 200))
        theBigClock.timezone = NSTimeZone(name: aClockView)
        view.addSubview(theBigClock)
      
             print(aClockView)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
      
        super.viewWillAppear(animated)
    }


    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
