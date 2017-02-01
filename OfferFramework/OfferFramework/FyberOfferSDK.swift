//
//  FyberOfferSDK.swift
//  FyberOffer
//
//  Created by Shabir Jan on 30/01/2017.
//  Copyright © 2017 Shabir Jan. All rights reserved.
//

import Foundation
import UIKit
//MARK : Optional Delegates that will update users regarding offers fetch
@objc public protocol FyberOfferDelegates
{
    //Offers are fetched and loaded into TableView
    @objc optional func offersDidLoad()
    
    //Log error produced during the fetching process
    @objc optional func offersLoadFailedWithError(error:String)
    
    //Log the offer that is selected by the user
    @objc optional func userSelectedOffer(offer:FyberOfferModel)
    
    //user closed the offers controller
    @objc optional func offersDidClose()
    
    //tell the total number of offers received
    @objc optional func offersRecevied(totalOffers:Int)
    
    //update every time an offer is appeared into the tableview
    @objc optional func offerDidLoadOnView(offer:FyberOfferModel)
    
}


public class FyberOfferSDK{
    
    let fybOptions : FYBOfferOptions
    public var delegate : FyberOfferDelegates?
    
    public init(options:FYBOfferOptions) {
        fybOptions = options
    }
    
    //Public Method of the SDK which is exposed to the as method that will initated the Offers Controller
    public func loadOffers(parentController:UIViewController){
        let storyboard = UIStoryboard(name: "OffersStoryboard", bundle: Bundle(for: OffersViewController.self))
        
        if let offerVC = storyboard.instantiateViewController(withIdentifier: "offerVC") as? OffersViewController
        {
            offerVC.delegate = delegate
            offerVC.options = fybOptions
            offerVC.parentController = parentController
            parentController.present(offerVC, animated: true, completion: nil)
        }
    }
}
