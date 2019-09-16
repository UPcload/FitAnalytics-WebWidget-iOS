//
//  ViewController.m
//  FitAnalytics-Demo
//
//  Created by FitAnalytics on 16/12/16.
//  Copyright © 2016 FitAnalytics. All rights reserved.
//

#import <UIKit/UIKit.h>
@import PromiseKit;

#import "ViewController.h"

#import "FITAWebWidget+TestInterface.h"
#import "FITAWebWidgetHandler.h"

@interface ViewController () <FITAWebWidgetHandler> {

@protected
    PMKResolver readyResolve;
    PMKResolver initResolve;
    PMKResolver productLoadResolve;
    PMKResolver openResolve;
    PMKResolver closeResolve;
    PMKResolver recommendResolve;
} @end

@implementation ViewController

- (void)viewDidLoad
{
   [super viewDidLoad];

    // clone frame from top view container
    CGRect frame = [self.view frame];

    // create the WKWebView instance
    self.wkWebView = [[WKWebView alloc] initWithFrame:frame];
    [self.view addSubview:self.wkWebView];
}

#pragma mark - FITAWebWidgetHandler -

- (void)webWidgetDidBecomeReady:(FITAWebWidget *)widget
{
    if (readyResolve) {
        readyResolve(@[]);
        readyResolve = nil;
    }
}

- (void)webWidgetInitialized:(FITAWebWidget *)widget
{
    if (initResolve) {
        initResolve(@[]);
        initResolve = nil;
    }
}

- (void)webWidgetDidFailLoading:(FITAWebWidget *)widget withError:(NSError *)error
{
    if (initResolve) {
        initResolve(error);
        initResolve = nil;
    }
}

- (void)webWidgetDidLoadProduct:(FITAWebWidget *)widget productId:(NSString *)productId details:(NSDictionary *)details
{
    if (productLoadResolve) {
        productLoadResolve(@[ productId, details ]);
        productLoadResolve = nil;
    }
}

- (void) webWidgetDidFailLoadingProduct:(FITAWebWidget *)widget productId:(NSString *)productId details:(NSDictionary *)details
{
    if (productLoadResolve) {
        productLoadResolve([NSError errorWithDomain:@"fita" code:1001 userInfo:@{
            NSLocalizedDescriptionKey: @"Failed loading the product"
        }]);
        productLoadResolve = nil;
    }
}

- (void)webWidgetDidOpen:(FITAWebWidget *)widget productId:(NSString *)productId
{
    if (openResolve) {
        openResolve(@[ productId ]);
        openResolve = nil;
    }
}

- (void)webWidgetDidClose:(FITAWebWidget *)widget productId:(NSString *)productId size:(NSString *)size details:(NSDictionary *)details
{
    if (closeResolve) {
        closeResolve(@[ productId, details ]);
        closeResolve = nil;
    }
}

- (void)webWidgetDidRecommend:(FITAWebWidget *)widget productId:(NSString *)productId size:(NSString *)size details:(NSDictionary *)details
{
    if (recommendResolve) {
        recommendResolve(@[ productId, size, details ]);
        recommendResolve = nil;
    }
}

#pragma mark - TestInterface -

- (FITAWebWidget *)initializeWidget
{
    self.widget = [[FITAWebWidget alloc] initWithWKWebView:self.wkWebView handler:self];
    return self.widget;
}

- (void)disconnectWebView
{
    [self.wkWebView removeFromSuperview];
}

- (void)reconnectWebView
{
    [self.view addSubview:self.wkWebView];
}

// for testing the messaging interface
- (AnyPromise *)sendProductLoadMessage:(NSString *)productId details:(NSDictionary *)details
{
    ViewController *view = self;
    AnyPromise *promise = [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve){
        view->productLoadResolve = resolve;
    }];
    [self.widget sendCallbackMessage:@"load" arguments:@[ productId, details ]];

    return promise;
}

- (AnyPromise *)widgetLoad
{
    ViewController *view = self;
    AnyPromise *promise = [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve){
        view->readyResolve = resolve;
    }];
    [self.widget load];
    return promise;
}

- (AnyPromise *)widgetCreate:(nullable NSString *)productSerial options:(nullable NSDictionary *)options
{
    ViewController *view = self;
    AnyPromise *promise;

    if (productSerial != nil) {
        promise = [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve){
            view->productLoadResolve = resolve;
        }];
    } else {
        promise = [AnyPromise promiseWithValue: nil];
    }
    [self.widget create:productSerial options:options];
    return promise;
}

- (AnyPromise *)widgetOpen
{
    ViewController *view = self;
    AnyPromise *promise = [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve){
        view->openResolve = resolve;
    }];
    [self.widget open];
    return promise;
}

- (AnyPromise *)widgetOpenWithOptions:(nullable NSString *)productSerial options:(nullable NSDictionary *)options
{
    ViewController *view = self;
    AnyPromise *promise = [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve){
        view->openResolve = resolve;
    }];
    [self.widget openWithOptions:productSerial options:options];
    return promise;
}

- (AnyPromise *)widgetReconfigure:(nullable NSString *)productSerial options:(nullable NSDictionary *)options
{
    ViewController *view = self;
    AnyPromise *promise;

    if (productSerial != nil) {
        promise = [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve){
            view->productLoadResolve = resolve;
        }];
    } else {
        promise = [AnyPromise promiseWithValue: nil];
    }
    [self.widget reconfigure:productSerial options:options];
    return promise;
}

- (AnyPromise *)widgetClose
{
    ViewController *view = self;
    AnyPromise *promise = [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve){
        view->closeResolve = resolve;
    }];
    [self.widget close];
    return promise;
}

- (AnyPromise *)widgetRecommend
{
    ViewController *view = self;
    AnyPromise *promise = [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve){
        view->recommendResolve = resolve;
    }];
    [self.widget recommend];
    return promise;
}

- (AnyPromise *)setFormInputs:(NSDictionary *)inputs
{
    return [self.widget testSetHeight:[inputs valueForKey:@"height"]]
    .then(^() {
        return [self.widget testSetWeight:[inputs valueForKey:@"weight"]];
    })
    .then(^() {
        return [self.widget testSetWeight:[inputs valueForKey:@"weight"]];
    })
    .then(^() { return PMKAfter(1); })
    .then(^() {
        return [self.widget testSubmitBodyMassForm];
    })
    .then(^() { return PMKAfter(1); })
    .then(^() {
        return [self widgetClose];
    });
}

@end
