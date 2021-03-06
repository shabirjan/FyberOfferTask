//
//  FYBOfferOptions.swift
//  FyberOffer
//
//  Created by Shabir Jan on 30/01/2017.
//  Copyright © 2017 Shabir Jan. All rights reserved.
//

import Foundation

//This class is responsible for creating the options that will be entered by the user i.e appId, userid, and token key

public class FYBOfferOptions {
    let appID : String
    let userID : String
    let securityToken : String
    
    public  init(appID:String, userID:String, securityToken:String) {
        self.appID = appID
        self.userID =  userID
        self.securityToken = securityToken
    }
    
}
