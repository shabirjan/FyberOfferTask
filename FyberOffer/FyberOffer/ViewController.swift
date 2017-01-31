//
//  ViewController.swift
//  FyberOffer
//
//  Created by Shabir Jan on 30/01/2017.
//  Copyright © 2017 Shabir Jan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtToken: UITextField!
    @IBOutlet weak var txtUserID: UITextField!
    @IBOutlet weak var txtAppID: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadDefaultValues()
        
    }
    func loadDefaultValues(){
        guard let appID = UserDefaults.standard.object(forKey: "appID"),
        let userID = UserDefaults.standard.object(forKey: "userID"),
        let tokenID = UserDefaults.standard.object(forKey: "token")
        else {
          return
        }
        txtAppID.text = appID as? String
        txtUserID.text = userID as? String
        txtToken.text = tokenID as? String
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loadOffers(_ sender: Any) {
        let options = FYBOfferOptions(appID: txtAppID.text!, userID: txtUserID.text!, securityToken: txtToken.text!)
        let sdk = FyberOfferSDK(options: options)
        sdk.delegate = self
        sdk.loadOffers(parentController: self)
    }

}
extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
extension ViewController: FyberOfferDelegates{
    
    func offersDidLoad() {
        print("Offers fetched")
        
    }
    func offerDidLoadOnView(offer: FyberOfferModel)
    {
        print("Offer appeared \(offer.offerTitle)")
        
    }
    func offersDidClose() {
        print("Offers closed")
    }
   
    func offersRecevied(totalOffers: Int) {
        print("total offers are \(totalOffers)")
    }
    func offersLoadFailedWithError(error: String) {
        print("Offer failed to load due to \(error)")
    }
    func userSelectedOffer(offer: FyberOfferModel) {
        print("User selected offer \(offer.offerTitle)")
    }
    
    
}
