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
    var delegate : FyberOfferDelegates?
    let options : FYBOfferOptions?
    let baseUrl = "http://api.fyber.com/feed/v1/offers.json?"
    var imageCache = [String:UIImage]()
    
    init(options : FYBOfferOptions) {
        self.options = options
    }
    
    //Public Method, Only this method will be exposed to Controller
    func fetchOffers(completion:@escaping ([FyberOfferModel]) -> Void, failure:@escaping (String) -> Void){
        let prepopulatedParameters  = [("format","json"),("local","DE"),("offer_types","112"),("ip","109.235.143.113")]
        fetchOffersFromUrl(params: prepopulatedParameters,completion: completion,failure: failure )
        
    }
    func fetchImage(url: String, completion:@escaping( _ img:UIImage?) -> ()){
        fetchImageFromUrl(url: url, completion: completion)
    }
    
    //Private Methods
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
                                        failure("")
                                    }
                                    self.delegate?.offersLoadFailedWithError!(error: "No Offers Found")
                                }
                            }
                            
                        }else{
                            DispatchQueue.main.async {
                                failure("")
                            }
                            self.delegate?.offersLoadFailedWithError!(error: "Corrupt Data, Signature mismatched")
                        }
                        
                    }else{
                        DispatchQueue.main.async {
                            failure("")
                        }
                        self.delegate?.offersLoadFailedWithError!(error: "No Signature Found in response")
                    }
                }else{
                    DispatchQueue.main.async {
                        failure("")
                    }
                    self.delegate?.offersLoadFailedWithError?(error: error!.localizedDescription)
                }
            }).resume()
        }else{
            DispatchQueue.main.async {
                failure("")
            }
            self.delegate?.offersLoadFailedWithError?(error: "URL Error")
        }
        
        
    }
    
    private func generateParametersForUrl(params:[(String,String)]) -> URL{
        
        let currentDate = NSDate()
        let uuidString = ASIdentifierManager.shared().isAdvertisingTrackingEnabled ? ASIdentifierManager.shared().advertisingIdentifier.uuidString : ""
        let trackingEnabled = ASIdentifierManager.shared().isAdvertisingTrackingEnabled ? "true" : "false"
        
        
        let allParams = params + [("appid",options!.appID),("uid",options!.userID),("os_version",UIDevice.current.systemVersion),("timestamp",String(Int64(currentDate.timeIntervalSince1970))),("apple_idfa_",uuidString),("apple_idfa_tracking_enabled",trackingEnabled)]
        
        
        var requestString = allParams.sorted(by: ({$0.0 < $1.0})).map({$0.0 + "=" + $0.1}).reduce("", {$0 + "&" + $1})
        
        
        
        return generateURLWithHash(requestString: String(requestString.characters.dropFirst()))!
    }
    
    private func generateURLWithHash(requestString : String) -> URL?{
        let sha1 = (requestString + "&" + options!.securityToken).sha1().lowercased()
        if sha1.isEmpty{
            return nil
        }
        else{
            return  URL(string: self.baseUrl + requestString + "&hashkey=" + sha1)
        }
        
    }
    
}
