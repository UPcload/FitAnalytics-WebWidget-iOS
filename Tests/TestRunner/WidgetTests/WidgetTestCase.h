//
//  WidgetTestCase.h
//  TestRunner
//
//  Created by FitAnalytics on 13/06/2017.
//  Copyright © 2017 FitAnalytics. All rights reserved.
//

#ifndef WidgetTestCase_h
#define WidgetTestCase_h

#import <XCTest/XCTest.h>

// application-specific
#import "AppDelegate.h"
#import "ViewController.h"
#import "FITAWebWidget+TestInterface.h"

@interface WidgetTestCase : XCTestCase {

// add instance variables to the test case class
@protected
    ViewController *viewController;
    WKWebView *webView;
    FITAWebWidget *widget;
}

- (void)initContext;

@end

#endif /* WidgetTestCase_h */
