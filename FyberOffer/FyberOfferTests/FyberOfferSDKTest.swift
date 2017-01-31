//
//  FyberOfferSDKTest.swift
//  FyberOffer
//
//  Created by Shabir Jan on 31/01/2017.
//  Copyright © 2017 Shabir Jan. All rights reserved.
//

import XCTest

class FyberOfferSDKTest: XCTestCase {
    var sdk: NetworkManager?
    override func setUp() {
        super.setUp()
        let options = FYBOfferOptions(appID: "2070", userID: "spiderman", securityToken: "1c915e3b5d42d05136185030892fbb846c278927")
        sdk = NetworkManager(options: options)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testOffersFetchRequest(){
        let expectations = expectation(description: "testing offers by fetching from server")
        sdk?.fetchOffers(completion: { (offers) in
            if offers.count > 0{
                expectations.fulfill()
                XCTAssert(true, "pass")
            }
        }, failure: { (error) in
            XCTAssert(false, "fail")
        })
        waitForExpectations(timeout: 10) { (error) in
            guard let error = error  else { return }
            print(error.localizedDescription)
        }
    }
    func testImageDownload(){
        let expectations = expectation(description: "testing image download method")
        sdk?.fetchImage(url: "http://cdn4.sponsorpay.com/app_icons/56913/big_mobile_icon.png", completion: { (data) in
            if data != nil{
                expectations.fulfill()
                XCTAssert(true, "pass")
            }else{
                XCTAssert(false, "fail")
            }
        })
        waitForExpectations(timeout: 10) { (error) in
            guard let error = error else { return }
           
        }
    }
    
    
}
