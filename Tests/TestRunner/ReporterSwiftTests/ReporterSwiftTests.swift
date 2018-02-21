//
//  ReportedSwiftTests.swift
//
//  Copyright © 2018 FitAnalytics. All rights reserved.
//

import XCTest
import PromiseKit

class ReporterSwiftTests: XCTestCase {
    var viewController:ViewController?
    var webView:UIWebView?
    var widget:FITAWebWidget?
    var reporter:FITAPurchaseReporter?

    func initContext () {
        let uiapp:UIApplication = UIApplication.shared
        let delegate:AppDelegate = uiapp.delegate as! AppDelegate
        viewController = delegate.initialViewController as? ViewController
        reporter = FITAPurchaseReporter()
    }

    func testSwiftPlain() {
        self.initContext()
        let expectation:XCTestExpectation = self.expectation(description: "finished")

        let report:FITAPurchaseReport = FITAPurchaseReport()

        report.orderId = "12345"
        report.userId = "X53RSwaOlvHXrysT"
        report.productSerial = "test-case|1"
        report.shopArticleCode = "test-article1"
        report.purchasedSize = "M tåll"
        report.sizeRegion = "EU"
        report.price = NSDecimalNumber.init(string: "30.0")
        report.currency = "EUR"
        report.shopCountry = "DE"
        report.shopLanguage = "de"
        report.shopSizingSystem = "MANUFACTURED"
        report.ean = "9783598215001"
        report.funnel = "sizeAdvisor"
    
        reporter!.send(report, completionHandler:{ (error:Error?) -> () in
            if error != nil {
                XCTAssertNil(error)
                expectation.fulfill()
            } else {
                NSLog("reporter done")
                expectation.fulfill()
            }
        })

        self.waitForExpectations(timeout: 10, handler: { error in
            XCTAssertNil(error)
        })
    }

    func testSwiftPlainWithDictionary() {
        self.initContext()
        let expectation:XCTestExpectation = self.expectation(description: "finished")

        let dict:[String: Any] = [
            "orderId": "51-13412",
            "productSerial": "test-case2",
            "shopArticleCode": "test-article2",
            "purchasedSize": "34/32",
            "sizeRegion": "US",
            "price": NSDecimalNumber.init(string: "60.0"),
            "currency": "USD",
            "shopCountry": "US",
            "shopLanguage": "en",
            "shopSizingSystem": "MANUFACTURED",
            "ean": "9783598215221",
            "funnel": "sizeChart"
        ]

        let report:FITAPurchaseReport = FITAPurchaseReport.init(dictionary: dict)

        XCTAssertTrue(report.orderId == "51-13412")
        XCTAssert(report.price == NSDecimalNumber.init(value: 60))
        XCTAssertNil(report.userId)

        reporter!.send(report, completionHandler:{ (error:Error?) -> () in
            if error != nil {
                XCTAssertNil(error)
                expectation.fulfill()
            } else {
                NSLog("reporter done")
                expectation.fulfill()
            }
        })

        self.waitForExpectations(timeout: 10, handler: { error in
            XCTAssertNil(error)
        })
    }
}
