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

- (void)testWidgetContainerLoad {
    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];

    [viewController widgetLoad].then(^(){
        NSLog(@"widget load");
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

- (void)testJavascriptEval {
    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];

    [viewController widgetLoad].then(^(){
        return [widget evaluateJavaScriptAsync:@"String(1 + 1)"];
    })
    .then(^(NSString *res) {
        XCTAssertEqualObjects(res, @"2");
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

- (void)testDriverInstall {
    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];

    [viewController widgetLoad].then(^(){
    }).then(^(){
        return [widget initializeDriver];
    }).then(^(){
        return [widget evaluateJavaScriptAsync:@"JSON.stringify(window.__driver)"];
    }).then(^(NSString *res) {
        XCTAssertEqualObjects(res, @"{}");
        return [widget evaluateJavaScriptAsync:@"JSON.stringify(!!window.__widgetManager)"];
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

- (void)testWidgetCreateAndOpen {
    [self initContext];
    XCTestExpectation *expectation = [self expectationWithDescription:@"finished"];

    [viewController widgetLoad].then(^(){
    }).then(^(){
        return [widget initializeDriver];
    }).then(^(){
        return [viewController widgetCreate:@"upcload-XX-test" options:nil];
    }).then(^(NSArray *res) {
        XCTAssertEqualObjects([res objectAtIndex:0], @"upcload-XX-test");
        return [viewController widgetOpen];
    }).then(^(NSArray *res) {
        XCTAssertEqualObjects([res objectAtIndex:0], @"upcload-XX-test");
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
