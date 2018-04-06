//
//  ViewController.m
//  Framework Example
//
//  Copyright © 2018 FitAnalytics. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () <FITAWebWidgetHandler>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // clone frame from UIWebView
    CGRect frame = [self.view frame];
    
    self.webView = [[UIWebView alloc] initWithFrame:frame];
    [self.view addSubview:self.webView];
    
    self.widget = [[FITAWebWidget alloc] initWithWebView:self.webView handler:self];
    [self.widget load];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FITAWebWidgetHandler -

- (void)webWidgetDidBecomeReady:(FITAWebWidget *)widget
{
    NSLog(@"READY");
}

- (void)webWidgetInitialized:(FITAWebWidget *)widget
{
    NSLog(@"INIT");
}

- (void)webWidgetDidLoadProduct:(FITAWebWidget *)widget productId:(NSString *)productId details:(NSDictionary *)details
{
    NSLog(@"LOAD event %@", productId);
}

- (void) webWidgetDidFailLoadingProduct:(FITAWebWidget *)widget productId:(NSString *)productId details:(NSDictionary *)details
{
    NSLog(@"LOADERROR event %@", productId);
}

- (void)webWidgetDidOpen:(FITAWebWidget *)widget productId:(NSString *)productId
{
    NSLog(@"OPEN event %@", productId);
}

- (void)webWidgetDidClose:(FITAWebWidget *)widget productId:(NSString *)productId size:(NSString *)size details:(NSDictionary *)details
{
    NSLog(@"CLOSE event %@, %@", productId, size);
}

- (void)webWidgetDidRecommend:(FITAWebWidget *)widget productId:(NSString *)productId size:(NSString *)size details:(NSDictionary *)details
{
    NSLog(@"RECOMMEND event %@, %@", productId, size);
}

@end
