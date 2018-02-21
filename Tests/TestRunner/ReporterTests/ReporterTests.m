//
//  ReporterTests.m
//  ReporterTests
//
//  Copyright © 2017 FitAnalytics. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ReporterTestCase.h"

#import "FITAPurchaseReporter+TestInterface.h"

@interface ReporterTests : ReporterTestCase
@end

@implementation ReporterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testReporterPlain {
    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];

    FITAPurchaseReport *report = [[FITAPurchaseReport alloc] init];

    report.orderId = @"12345";
    report.userId = @"X53RSwaOlvHXrysT";
    report.productSerial = @"test-case|1";
    report.shopArticleCode = @"test-article1";
    report.purchasedSize = @"M tåll";
    report.sizeRegion = @"EU";
    report.price = [NSDecimalNumber decimalNumberWithString:@"30.0"];
    report.currency = @"EUR";
    report.shopCountry = @"DE";
    report.shopLanguage = @"de";
    report.shopSizingSystem = @"MANUFACTURED";
    report.ean = @"9783598215001";
    report.funnel = @"sizeAdvisor";

    [reporter sendReportAsync:report]
    .then(^() { return PMKAfter(1); }) // wait for 1 sec for both requests to finish
    .then(^(){
        NSLog(@"reporter done");
        [expectation fulfill];
    })
    .catch(^(NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail();
        [expectation fulfill];
    });

    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}


- (void)testReporterPlainDictionary {
    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];

    FITAPurchaseReport *report = [[FITAPurchaseReport alloc] initWithDictionary:@{
        @"orderId": @"51-13412",
        @"productSerial": @"test-case2",
        @"shopArticleCode": @"test-article2",
        @"purchasedSize": @"34/32",
        @"sizeRegion": @"US",
        @"price": [NSDecimalNumber decimalNumberWithString:@"60.55"],
        @"currency": @"USD",
        @"shopCountry": @"US",
        @"shopLanguage": @"en",
        @"shopSizingSystem": @"MANUFACTURED",
        @"ean": @"9783598215221",
        @"funnel": @"sizeChart"
    }];

    [reporter sendReportAsync:report]
    .then(^() { return PMKAfter(1); }) // wait for 1 sec for both requests to finish
    .then(^(){
        NSLog(@"reporter done");
        [expectation fulfill];
    })
    .catch(^(NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail();
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testReporterDictionaryAsDefaults {
    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];

    NSDictionary *orderDefaults = @{
        @"orderId": @"A7423",
        @"currency": @"EUR",
        @"shopCountry": @"FR",
        @"shopLanguage": @"fr",
        @"funnel": @"sizeChart"
    };

    FITAPurchaseReport *report = [[FITAPurchaseReport alloc] initWithDictionary:orderDefaults];

    report.productSerial = @"test-69992";
    report.purchasedSize = @"48";
    report.sizeRegion = @"EU";
    report.price = [NSDecimalNumber decimalNumberWithString:@"34"];
    report.currency = @"EUR";

    [reporter sendReportAsync:report]
    .then(^() { return PMKAfter(1); }) // wait for 1 sec for both requests to finish
    .then(^(){
        NSLog(@"reporter done");
        [expectation fulfill];
    })
    .catch(^(NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail();
        [expectation fulfill];
    });

    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testReporterNoCallback {
    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];

    FITAPurchaseReport *report = [[FITAPurchaseReport alloc] init];

    report.orderId = @"222-nocallback";
    report.productSerial = @"test-case|2";
    report.purchasedSize = @"L";
    report.price = [NSDecimalNumber decimalNumberWithString:@"30"];
    report.currency = @"EUR";
    report.shopCountry = @"DE";

    [reporter sendReport:report];

    PMKAfter(1)
    .then(^(){
        NSLog(@"reporter done");
        [expectation fulfill];
    });

    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

@end
