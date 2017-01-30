//
//  OffersViewController.swift
//  FyberOffer
//
//  Created by Shabir Jan on 30/01/2017.
//  Copyright © 2017 Shabir Jan. All rights reserved.
//

import UIKit

class OffersViewController: UIViewController {

    var delegate: FyberOfferDelegates?
    var options : FYBOfferOptions?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnClosePressed(_ sender: Any) {
        delegate?.offersDidClose?()
        self.dismiss(animated: true, completion: nil)
    }

}
