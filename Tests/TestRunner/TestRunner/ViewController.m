//
//  ViewController.m
//  FitAnalytics-Demo
//
//  Created by FitAnalytics on 16/12/16.
//  Copyright © 2016 FitAnalytics. All rights reserved.
//

#import "ViewController.h"

#import "FITAWebWidget+TestInterface.h"
#import "FITAWebWidgetHandler.h"

@interface ViewController () <FITAWebWidgetHandler>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) FITAWebWidget *widget;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.widget = [[FITAWebWidget alloc] initWithWebView:self.webView handler:self];
    [self.widget load];
}

#pragma mark - FITAWebWidgetHandler -

- (void)webWidgetDidBecomeReady:(FITAWebWidget *)widget
{
    NSLog(@"XX READY");
    [widget initializeDriver];
    NSLog(@"XX widget eval: %@", [widget evalJavascript:@"JSON.stringify(window.__driver)"]);
    NSLog(@"XX widget eval: %@", [widget evalJavascript:@"!!window.__widgetManager"]);
    NSLog(@"XX widget eval: %@", [widget evalJavascript:@"__driver.hasManager()"]);
    NSLog(@"XX widget eval: %@", [widget evalJavascript:@"__driver['hasManager']()"]);
    
    NSLog(@"XX Is Manager present: %@", [widget testHasManager]);
    [widget createWithOptions:nil options:@{ @"productSerial": @"upcload-XX-test" }];
}

- (void)webWidgetInitialized:(FITAWebWidget *)widget
{
    NSLog(@"XX INIT");
    NSLog(@"XX Is Widget present: %@", [widget testHasWidget]);
    [widget open];
}

- (void)webWidgetDidLoadProduct:(FITAWebWidget *)widget productId:(NSString *)productId details:(NSDictionary *)details
{
    NSLog(@"XX LOAD event %@", productId);
}

- (void) webWidgetDidFailLoadingProduct:(FITAWebWidget *)widget productId:(NSString *)productId details:(NSDictionary *)details
{
    NSLog(@"XX LOADERROR event %@", productId);
}

- (void)webWidgetDidOpen:(FITAWebWidget *)widget productId:(NSString *)productId
{
    NSLog(@"XX OPEN event %@", productId);
    NSLog(@"XX is widget open: %@", [widget testIsWidgetOpen]);
    [self performSelector:@selector(setFormInputs:) withObject:@{ @"height": @"180", @"weight": @"90" } afterDelay:2.0];
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
