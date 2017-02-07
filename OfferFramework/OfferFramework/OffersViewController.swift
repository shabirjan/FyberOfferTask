//
//  OffersViewController.swift
//  FyberOffer
//
//  Created by Shabir Jan on 30/01/2017.
//  Copyright © 2017 Shabir Jan. All rights reserved.
//

import UIKit

class OffersViewController: UIViewController {
    
    
    var delegate: FyberOfferDelegate?
    var options : FYBOfferOptions?
    var networkManager : NetworkManager?
    var parentController : UIViewController?
    
    
    var allOffers = [FyberOfferModel]()
    
    @IBOutlet weak var offerTableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblNoOffers: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager = NetworkManager(options: self.options!)
        
        fetchOffers()
        
    }
    
    //Method to initiated NetworkManager class to fetch the offers and than display into the TableView
    func fetchOffers(){
         self.lblNoOffers.isHidden = true
        allOffers = []
        if self.options != nil {
            activityIndicator.startAnimating()
            networkManager?.delegate = delegate
            networkManager?.fetchOffers(completion: { [weak self] offers in
                self?.activityIndicator.stopAnimating()
                
                if offers.count > 0 {
                    self?.allOffers = offers
                    self?.delegate?.offersRecevied?(totalOffers: offers.count)
                    self?.offerTableView.isHidden = false
                    self?.offerTableView.reloadData()
                    self?.delegate?.offersDidLoad?()
                }
                else{
                    self?.delegate?.offersLoadFailedWithError?(error: "No Offers found")
                    self?.lblNoOffers.isHidden = false
                }
                }, failure: { (error) in
                    self.offerTableView.isHidden = true
                    self.lblNoOffers.isHidden = false
                    self.delegate?.offersLoadFailedWithError?(error: error)
                    self.activityIndicator.stopAnimating()
            })
        }else{
            
            self.delegate?.offersLoadFailedWithError?(error: "Invalid Options")
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Close the Controller
    @IBAction func btnClosePressed(_ sender: Any) {
        delegate?.offersDidClose?()
        parentController?.dismiss(animated: true, completion: nil)
    }
    
    //Refresh the Offers
    @IBAction func refreshOffers(_ sender: Any) {
        fetchOffers()
    }
    
}

//UITableView Delegate and DataSource methods
extension OffersViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allOffers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:OfferTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "offerCell") as? OfferTableViewCell
        if cell == nil {
            cell = OfferTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "offerCell")
        }
        let currentOffer = allOffers[indexPath.row]
        cell?.lblTitle.text = currentOffer.offerTitle
        networkManager?.fetchImage(url: currentOffer.offerThumbnail, completion: { (image) in
            cell?.thumbnailImage.image = image
        })
        self.delegate?.offerDidLoadOnView?(offer: currentOffer)
        
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOffer = self.allOffers[indexPath.row]
        self.delegate?.userSelectedOffer?(offer: selectedOffer)
        
    }
}
