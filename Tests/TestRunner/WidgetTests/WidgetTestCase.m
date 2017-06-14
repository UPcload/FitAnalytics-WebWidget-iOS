//
//  WidgetTestCase.m
//  TestRunner
//
//  Created by FitAnalytics on 13/06/2017.
//  Copyright © 2017 FitAnalytics. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WidgetTestCase.h"

#import "AppDelegate.h"
#import "ViewController.h"
#import "FITAWebWidget+TestInterface.h"

@implementation WidgetTestCase

- (void)setUp {
    [super setUp];
}

- (void)initContext {
    UIApplication *uiapp = [UIApplication sharedApplication];
    AppDelegate *delegate = (AppDelegate *)[uiapp delegate];
    viewController = (ViewController *)delegate.initialViewController;
    widget = [viewController initializeWidget];
}

@end
