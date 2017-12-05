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

    report.productSerial = @"test-1234567";
    report.price = @"34";
    report.currency = @"EUR";
    report.purchasedSize = @"S";

    [reporter sendReportAsync:report].then(^(){
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
        @"productSerial": @"test-1234567",
        @"price": @"34",
        @"currency": @"EUR",
        @"purchasedSize": @"S"
    }];

    [reporter sendReportAsync:report].then(^(){
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

@end
