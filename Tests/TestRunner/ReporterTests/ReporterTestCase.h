//
//  ReporterTestCase.h
//  TestRunner
//
//  Copyright © 2017 FitAnalytics. All rights reserved.
//

#ifndef ReporterTestCase_h
#define ReporterTestCase_h

#import <XCTest/XCTest.h>

// application-specific
#import "AppDelegate.h"
#import "ViewController.h"
#import "FITAWebWidget+TestInterface.h"
#import "FITAPurchaseReporter.h"

@interface ReporterTestCase : XCTestCase {
    
    // add instance variables to the test case class
@protected
    ViewController *viewController;
    UIWebView *webView;
    FITAWebWidget *widget;
    FITAPurchaseReporter *reporter;
}

- (void)initContext;

@end

#endif /* ReporterTestCase_h */
