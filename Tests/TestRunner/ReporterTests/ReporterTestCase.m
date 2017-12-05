//
//  WidgetTestCase.m
//  TestRunner
//
//  Copyright © 2017 FitAnalytics. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ReporterTestCase.h"

#import "AppDelegate.h"
#import "ViewController.h"
#import "FITAPurchaseReporter+TestInterface.h"

@implementation ReporterTestCase

- (void)initContext {
    UIApplication *uiapp = [UIApplication sharedApplication];
    AppDelegate *delegate = (AppDelegate *)[uiapp delegate];
    viewController = (ViewController *)delegate.initialViewController;
    reporter = [[FITAPurchaseReporter alloc] init];
}

@end
