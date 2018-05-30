//
//  AdvertisementSavedTableViewCell.swift
//  JapanIceTea
//
//  Created by Ferdinando Mirra on 22/02/18.
//  Copyright © 2018 7App, iOSDA. All rights reserved.
//

import UIKit

class AdvertisementSavedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var adLocalPhoto: UIImageView!
    @IBOutlet weak var adLocalName: UILabel!
    @IBOutlet weak var adLocalType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
