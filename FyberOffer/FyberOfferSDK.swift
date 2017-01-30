//
//  FyberOfferSDK.swift
//  FyberOffer
//
//  Created by Shabir Jan on 30/01/2017.
//  Copyright © 2017 Shabir Jan. All rights reserved.
//

import Foundation
import UIKit
//MARK : Optional Delegates
@objc protocol FyberOfferDelegates
{
    @objc optional func offersDidLoad()
    @objc optional func offersLoadFailedWithError(error:String)
    @objc optional func userSelectedOffer(offer:FyberOfferModel)
    @objc optional func offersDidClose()
    @objc optional func offersRecevied(totalOffers:Int)
    @objc optional func offerDidLoadOnView()
}


class FyberOfferSDK{
    
    let fybOptions : FYBOfferOptions
    var delegate : FyberOfferDelegates?
    
    init(options:FYBOfferOptions) {
        fybOptions = options
    }
    func loadOffers(parentController:UIViewController){
        let storyboard = UIStoryboard(name: "OffersStoryboard", bundle: nil)
        if let offerVC = storyboard.instantiateViewController(withIdentifier: "offerVC") as? OffersViewController
        {
            offerVC.delegate = delegate
            offerVC.options = fybOptions
            parentController.present(offerVC, animated: true, completion: nil)
        }
    }
}
