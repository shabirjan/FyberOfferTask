//
//  FyberOfferModel.swift
//  FyberOffer
//
//  Created by Shabir Jan on 30/01/2017.
//  Copyright © 2017 Shabir Jan. All rights reserved.
//

import Foundation
import SwiftyJSON
class FyberOfferModel:NSObject{
    
    let offerTitle : String
    let offerId: NSNumber
    let offerThumbnail:String
   
    
    init?(offerDictionary :JSON){
        guard let id = offerDictionary["offer_id"].number,
            let title = offerDictionary["title"].string,
            let thumbnail = offerDictionary["thumbnail"]["hires"].string else { return nil}
        self.offerId = id
        self.offerTitle = title
        self.offerThumbnail = thumbnail
    }
}
