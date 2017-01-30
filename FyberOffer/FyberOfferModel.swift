//
//  FyberOfferModel.swift
//  FyberOffer
//
//  Created by Shabir Jan on 30/01/2017.
//  Copyright © 2017 Shabir Jan. All rights reserved.
//

import Foundation
class FyberOfferModel:NSObject{
    
    let offerTitle : String
    let offerId: Int
    let offerThumbnail:String
   
    
    init(title: String, id:Int, thumbnail:String) {
        self.offerTitle = title
        self.offerId = id
        self.offerThumbnail = thumbnail
        
    }
}
