//
//  NetworkManager.swift
//  FyberOffer
//
//  Created by Shabir Jan on 30/01/2017.
//  Copyright © 2017 Shabir Jan. All rights reserved.
//

import Foundation

class NetworkManager{
    var delegate : FyberOfferDelegates?
    let options : FYBOfferOptions
    let baseUrl = "http://api.fyber.com/feed/v1/offers.json?"
    
    init(options : FYBOfferOptions) {
       self.options = options
    }
    
    func fetchOffers(completion:[FyberOfferModel]){
        
    }

}
