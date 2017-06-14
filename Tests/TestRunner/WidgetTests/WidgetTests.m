//
//  WidgetTests.m
//  WidgetTests
//
//  Created by FitAnalytics on 14/06/2017.
//  Copyright © 2017 FitAnalytics. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WidgetTestCase.h"

@interface WidgetTests : WidgetTestCase
@end

@implementation WidgetTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWidgetLoad {
    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];
    
    [viewController widgetLoad].then(^(){
        NSLog(@"widget load");
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (void)testDriverInstall {
    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];

    [viewController widgetLoad].then(^(){
        return [widget initializeDriver];
    }).then(^(){
        return [widget evaluateJavaScriptAsync:@"JSON.stringify(window.__driver)"];
    }).then(^(NSString *res) {
        XCTAssertEqualObjects(res, @"{}");
        return [widget evaluateJavaScriptAsync:@"!!window.__widgetManager"];
    }).then(^(NSString *res) {
        XCTAssertEqualObjects(res, @"true", @"widget manager not present");
        return [widget testHasManager];
    }).then(^(NSString *res){
        XCTAssertEqualObjects(res, @"true", @"widget manager not present");
        [expectation fulfill];
    })
    .catch(^(NSError *error) {
        NSLog(@"Error: %@", error);
        XCTFail();
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        XCTAssert(!error);
    }];
}

@end
