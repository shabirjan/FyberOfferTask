//
//  OfferFunctionalTest.swift
//  OfferFramework
//
//  Created by Shabir Jan on 01/02/2017.
//  Copyright © 2017 Shabir Jan. All rights reserved.
//

import XCTest

class OfferFunctionalTest: XCTestCase {
    
    var viewController : OffersViewController!
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "OffersStoryboard", bundle: Bundle(for: OffersViewController.self))
        viewController  =  storyboard.instantiateViewController(withIdentifier: "offerVC") as? OffersViewController
        viewController.options = FYBOfferOptions(appID: "2070", userID: "spiderman", securityToken: "1c915e3b5d42d05136185030892fbb846c278927")
        
        let _ = viewController.view
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIfViewControllerIsLoaded() {
        XCTAssertNotNil(viewController.view)
    }
    func testTableViewIsLoaded()
    {
        
        XCTAssertNotNil(viewController.offerTableView,"TableView not initated")
    }
    func testTableViewConnectedToDelegate(){
        XCTAssertNotNil(viewController.offerTableView.delegate,"Table delegate cannot be nil")
    }
    func  testFetchOffers() {
        let expectations = expectation(description: "testing offers by fetching from server")
        viewController.fetchOffers()
        
        
        if viewController.allOffers.count>0 {
            expectations.fulfill()
        }
        waitForExpectations(timeout: 5) { (error) in
            print(error?.localizedDescription)
        }
        
    }
  
    
    
}
