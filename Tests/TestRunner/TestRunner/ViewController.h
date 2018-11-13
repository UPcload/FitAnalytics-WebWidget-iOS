//
//  ViewController.h
//  TestRunner
//
//  Created by FitAnalytics on 30/01/17.
//  Copyright © 2017 FitAnalytics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@import PromiseKit;

#import "FITAWebWidget+TestInterface.h"

@interface ViewController : UIViewController

@property (strong, nonatomic, nullable) UIWebView *uiWebView;
@property (strong, nonatomic, nullable) WKWebView *wkWebView;
@property BOOL useUIWebView;

@property (nonatomic, strong, nullable) FITAWebWidget *widget;

- (nonnull FITAWebWidget *)initializeWidget;

- (void)disconnectWebView;
- (void)reconnectWebView;

- (nonnull AnyPromise *)widgetLoad;
- (nonnull AnyPromise *)sendProductLoadMessage:(nullable NSString *)productId details:(nullable NSDictionary *)details;

- (nonnull AnyPromise *)widgetCreate:(nullable NSString *)productSerial options:(nullable NSDictionary *)options;
- (nonnull AnyPromise *)widgetOpen;
- (nonnull AnyPromise *)widgetOpenWithOptions:(nullable NSString *)productSerial options:(nullable NSDictionary *)options;
- (nonnull AnyPromise *)widgetReconfigure:(nullable NSString *)productSerial options:(nullable NSDictionary *)options;
- (nonnull AnyPromise *)widgetClose;
- (nonnull AnyPromise *)widgetRecommend;
- (nonnull AnyPromise *)setFormInputs:(nonnull NSDictionary *)inputs;

@end

