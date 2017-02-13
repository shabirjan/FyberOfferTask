//
//  NetworkManager.swift
//  FyberOffer
//
//  Created by Shabir Jan on 30/01/2017.
//  Copyright © 2017 Shabir Jan. All rights reserved.
//

import Foundation
import AdSupport
import CryptoSwift
import SwiftyJSON
class NetworkManager{
    let options : FYBOfferOptions?
    let baseUrl = "http://api.fyber.com/feed/v1/offers.json?"
    var imageCache = [String:UIImage]()
    
    init(options : FYBOfferOptions) {
        self.options = options
    }
    //Public Method, Only this method will be exposed to OfferViewController  that will first generate the url by adding the default parameters provided in the challenge   and passing that parameters to private method to fetch the offers by generating the mandatory parameters and this will return the response to the OfferViewController
    func fetchOffers(completion:@escaping ([FyberOfferModel]) -> Void, failure:@escaping (String) -> Void){
        let prepopulatedParameters  = [("format","json"),("local","DE"),("offer_types","112"),("ip","109.235.143.113")]
        fetchOffersFromUrl(params: prepopulatedParameters,completion: completion,failure: failure )
        
    }
    //Public Method to fetch thumbnail image for each offer by calling private method by providing the url of the image and this will return the image to calling Controller and only this will be exposed to the OfferViewController
    func fetchImage(url: String, completion:@escaping( _ img:UIImage?) -> ()){
        fetchImageFromUrl(url: url, completion: completion)
    }
    
    //Private Methods
    
    //Fetch thumbnail image for given url by checking if it is avaiable in the cache or not
    private func fetchImageFromUrl(url:String, completion:@escaping(_ img : UIImage?)-> ()){
        if  let image = self.imageCache[url] {
            completion(image)
        }
        else{
            
            URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
                if error == nil {
                    guard let image = UIImage(data: data!) else { return }
                    self.imageCache[url] = image
                    DispatchQueue.main.async {
                        completion(image)
                        
                    }
                    
                }else{
                    completion(nil)
                    print("image download failed : \(error?.localizedDescription)")
                }
                }.resume()
        }
    }
    
    
    //Return the offers by using default parameters to generate mandatory parameters and than generate url by hasing (steps provided in the documentation) and checks for the validity of the signature and data as well
    private func fetchOffersFromUrl(params:[(String,String)],completion: @escaping ([FyberOfferModel]) -> Void,failure:@escaping (String) -> Void){
        let requestURL = generateParametersForUrl(params: params)
        if !(requestURL.absoluteString.isEmpty) {
            URLSession.shared.dataTask(with: requestURL, completionHandler: { (data, response, error) in
                if error == nil{
                    guard let data = data else { return  }
                    if let sigatureValue = (response! as! HTTPURLResponse).allHeaderFields["X-Sponsorpay-Response-Signature"] as? String{
                        
                        let strData = String(data: data, encoding: String.Encoding.utf8)
                        let sha1 = (strData! + (self.options?.securityToken)!).sha1().lowercased()
                        
                        if sha1 == sigatureValue{
                            let allOffers = JSON(data:data)["offers"]
                            if allOffers.type == Type.array{
                                if allOffers.arrayValue.count > 0{
                                    DispatchQueue.main.async {
                                        completion(allOffers.arrayValue.flatMap(FyberOfferModel.init(offerDictionary:)))
                                    }
                                    
                                }else{
                                    DispatchQueue.main.async {
                                        failure("No Offers Found")
                                    }
                                    
                                }
                            }
                            
                        }else{
                            DispatchQueue.main.async {
                                failure("Corrupt Data, Signature mismatched")
                            }
                            
                        }
                        
                    }else{
                        DispatchQueue.main.async {
                            failure("No Signature Found in response")
                        }
                        
                    }
                }else{
                    DispatchQueue.main.async {
                        failure((error?.localizedDescription)!)
                    }
                }
            }).resume()
        }else{
            DispatchQueue.main.async {
                failure("")
            }
        }
        
        
    }
    //Generate URL for mandatory parameters
    private func generateParametersForUrl(params:[(String,String)]) -> URL{
        
        let currentDate = NSDate()
        let uuidString = ASIdentifierManager.shared().isAdvertisingTrackingEnabled ? ASIdentifierManager.shared().advertisingIdentifier.uuidString : ""
        let trackingEnabled = ASIdentifierManager.shared().isAdvertisingTrackingEnabled ? "true" : "false"
        
        
        let allParams = params + [("appid",options!.appID),("uid",options!.userID),("os_version",UIDevice.current.systemVersion),("timestamp",String(Int64(currentDate.timeIntervalSince1970))),("apple_idfa_",uuidString),("apple_idfa_tracking_enabled",trackingEnabled)]
        
        
        var requestString = allParams.sorted(by: ({$0.0 < $1.0})).map({$0.0 + "=" + $0.1}).reduce("", {$0 + "&" + $1})
        
        
        
        return generateURLWithHash(requestString: String(requestString.characters.dropFirst()))!
    }
    
    //Generate Hash from the parameters and return the URL
    func generateURLWithHash(requestString : String) -> URL?{
        let sha1 = (requestString + "&" + options!.securityToken).sha1().lowercased()
        if sha1.isEmpty{
            return nil
        }
        else{
            return  URL(string: self.baseUrl + requestString + "&hashkey=" + sha1)
        }
        
    }
    
}
