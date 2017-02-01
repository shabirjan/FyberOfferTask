//
//  FyberOfferModel.swift
//  FyberOffer
//
//  Created by Shabir Jan on 30/01/2017.
//  Copyright © 2017 Shabir Jan. All rights reserved.
//

import Foundation
import SwiftyJSON


//Model class for the offer object
public class FyberOfferModel:NSObject{
    
    public  let offerTitle : String
    public let offerId: NSNumber
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
