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
    PMKResolver recommendResolve;
} @end

@implementation ViewController

- (void)viewDidLoad
{
   [super viewDidLoad];
}

#pragma mark - FITAWebWidgetHandler -

- (void)webWidgetDidBecomeReady:(FITAWebWidget *)widget
{
    if (readyResolve) {
        readyResolve(widget);
    }
}

- (void)webWidgetInitialized:(FITAWebWidget *)widget
{
    if (initResolve) {
        initResolve(widget);
    }
    NSLog(@"XX INIT event");

    [widget testHasWidget]
    .then(^(NSString *res){
        NSLog(@"XX is widget present: %@", res);
        [widget open];
    })
    .catch(^(NSError *error) {
        NSLog(@"XX error: %@", error);
    });
}

- (void)webWidgetDidLoadProduct:(FITAWebWidget *)widget productId:(NSString *)productId details:(NSDictionary *)details
{
   if (productLoadResolve) {
        productLoadResolve(widget);
    }
    NSLog(@"XX LOAD event %@", productId);
}

- (void) webWidgetDidFailLoadingProduct:(FITAWebWidget *)widget productId:(NSString *)productId details:(NSDictionary *)details
{
//    if (productLoadResolve) {
//        productLoadResolve();
//    }
    NSLog(@"XX LOADERROR event %@", productId);
}

- (void)webWidgetDidOpen:(FITAWebWidget *)widget productId:(NSString *)productId
{
    if (openResolve) {
        openResolve(widget);
    }
    NSLog(@"XX OPEN event %@", productId);
    NSLog(@"XX is widget open: %@", [widget testIsWidgetOpen]);
    [self performSelector:@selector(setFormInputs:) withObject:@{ @"height": @"180", @"weight": @"90" } afterDelay:2.0];
}

#pragma mark - TestInterface -

- (FITAWebWidget *)initializeWidget
{
    self.widget = [[FITAWebWidget alloc] initWithWebView:self.webView handler:self];
    return self.widget;
}

- (AnyPromise *)widgetLoad
{
    ViewController *view = self;
    [self.widget load];
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve){
        view->readyResolve = resolve;
    }];
}

- (void)setFormInputs:(NSDictionary *)inputs
{
    [self.widget testSetHeight:[inputs valueForKey:@"height"]];
    [self.widget testSetWeight:[inputs valueForKey:@"weight"]];
    NSLog(@"XX HEIGHT %@", [self.widget testGetHeight]);
    NSLog(@"XX WEIGHT %@", [self.widget testGetWeight]);
    [self performSelector:@selector(submitForm) withObject:nil afterDelay:2.0];
}
- (void)submitForm
{
    [self.widget testSubmitBodyMassForm];
    [self performSelector:@selector(closeWidget) withObject:nil afterDelay:2.0];
}
- (void)closeWidget
{
    [self.widget close];
}
- (void)webWidgetDidClose:(FITAWebWidget *)widget productId:(NSString *)productId size:(NSString *)size details:(NSDictionary *)details
{
    NSLog(@"XX CLOSE event %@, %@", productId, size);
    [self performSelector:@selector(getRecommendation) withObject:nil afterDelay:1.0];
}
- (void)getRecommendation
{
    [self.widget recommend];
}
- (void)webWidgetDidRecommend:(FITAWebWidget *)widget productId:(NSString *)productId size:(NSString *)size details:(NSDictionary *)details
{
    NSLog(@"XX RECOMMEND event %@, %@", productId, size);
}

@end
