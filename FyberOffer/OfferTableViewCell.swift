//
//  OfferTableViewCell.swift
//  FyberOffer
//
//  Created by Shabir Jan on 31/01/2017.
//  Copyright © 2017 Shabir Jan. All rights reserved.
//

import UIKit

class OfferTableViewCell: UITableViewCell {

    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var thumbnailImage : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
