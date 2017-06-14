//
//  FITAWebWidget+TestInterface.h
//  FitAnalytics-WebWidget-SDK
//
//  Created by FitAnalytics on 16/12/16.
//  Copyright © 2016 FitAnalytics. All rights reserved.
//

#ifndef FITAWebWidget_TestInterface_h
#define FITAWebWidget_TestInterface_h

#import <Foundation/Foundation.h>

@import PromiseKit;

#import "FITAWebWidget.h"

@interface FITAWebWidget (TestInterface)

@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, weak) WKWebView *wkWebView;

// original eval method from FITAWebWidget class
- (void)evaluateJavaScript:(NSString *)code done:(void (^)(id, NSError *))done;

// promisified eval method
- (AnyPromise *)evaluateJavaScriptAsync:(NSString *)code;

- (AnyPromise *)initializeDriver;
- (AnyPromise *)driverCall:(NSString *)name arguments:(NSArray *)arguments;

- (AnyPromise *)testHasManager;
- (AnyPromise *)testHasWidget;
- (AnyPromise *)testIsWidgetOpen;
- (AnyPromise *)testGetScreenName;
- (AnyPromise *)testGetHeight;
- (AnyPromise *)testGetWeight;
- (AnyPromise *)testSetHeight:(NSString *)value;
- (AnyPromise *)testSetWeight:(NSString *)value;
- (AnyPromise *)testSubmitBodyMassForm;

@end

#endif /* FITAWebWidget_TestInterface_h */
