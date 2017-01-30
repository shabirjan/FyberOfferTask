//
//  FyberOfferModel.swift
//  FyberOffer
//
//  Created by Shabir Jan on 30/01/2017.
//  Copyright © 2017 Shabir Jan. All rights reserved.
//

import Foundation
class FyberOfferModel:NSObject{
    let offerLink : String
    let offerTitle : String
    let offerId: Int
    let offerTeaser:String
    let offerThumbnail:String
    let offerPayout : Int
    
    init(title: String,link:String, id:Int, teaser:String, thumbnail:String, payout:Int) {
        self.offerTitle = title
        self.offerLink = link
        self.offerId = id
        self.offerTeaser = teaser
        self.offerThumbnail = thumbnail
        self.offerPayout = payout
    }
}
