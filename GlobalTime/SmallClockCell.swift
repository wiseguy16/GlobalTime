//
//  SmallClockCell.swift
//  GlobalTime
//
//  Created by Gregory Weiss on 8/22/16.
//  Copyright © 2016 Gregory Weiss. All rights reserved.
//

import UIKit
import Foundation

class SmallClockCell: UITableViewCell
{
    // var clockView: ClockView!
    
    @IBOutlet weak var timeZoneAreaLabel: UILabel!
    @IBOutlet weak var smallClockView: ClockView!
    

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        

    }

}
