//
//  ViewController.m
//  FitAnalytics-Demo
//
//  Created by FitAnalytics on 16/12/16.
//  Copyright © 2016 FitAnalytics. All rights reserved.
//

#import "ViewController.h"

/**
 *Import the FITWebWidget Header and the Handler
 */
#import "FITAWebWidget.h"
#import "FITAWebWidgetHandler.h"

@interface ViewController () <FITAWebWidgetHandler>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *recommendButton;
@property (weak, nonatomic) IBOutlet UILabel *recommendDisplay;
@property (weak, nonatomic) IBOutlet UITextField *productIdInput;
@property (weak, nonatomic) IBOutlet UIButton *loadButton;

- (void)onLoad;
- (void)onOpen;
- (void)onClose;
- (void)onRecommend;

@property (nonatomic, strong) FITAWebWidget *widget;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.openButton addTarget:self action:@selector(onOpen) forControlEvents:UIControlEventTouchUpInside];
    self.openButton.enabled = NO;
    self.openButton.userInteractionEnabled = NO;

    [self.closeButton addTarget:self action:@selector(onClose) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton.enabled = NO;
    self.closeButton.userInteractionEnabled = NO;

    [self.recommendButton addTarget:self action:@selector(onRecommend) forControlEvents:UIControlEventTouchUpInside];
    self.recommendButton.enabled = NO;
    self.recommendButton.userInteractionEnabled = NO;
    
    [self.loadButton addTarget:self action:@selector(onLoad) forControlEvents:UIControlEventTouchUpInside];
    self.loadButton.enabled = NO;
    self.loadButton.userInteractionEnabled = NO;

    self.widget = [[FITAWebWidget alloc] initWithWebView:self.webView handler:self];
    [self.widget load];
}

- (void)setMessage:(NSString *)message {
    self.recommendDisplay.text = (message != nil ? message : @"");
}

- (IBAction)onLoad
{
    NSString *productSerial = self.productIdInput.text;

    NSLog(@"LOAD");

    if (productSerial != nil && ![productSerial isEqualToString:@""]) {
        [self.widget reconfigure:productSerial options:@{
            // we need to provide these two values here, otherwise many productSerials won't work
            @"language": @"en",
            @"shopCountry": @"US"
        }];
    } else {
        NSLog(@"Invalid productSerial: %@", productSerial);
        [self setMessage:@"Invalid product serial"];
    }
}

- (IBAction)onOpen
{
    [self.widget open];
}

- (IBAction)onClose
{
    [self.widget close];
}

- (IBAction)onRecommend
{
    [self.widget recommend];
}

#pragma mark - FITAWebWidgetHandler -

- (void)webWidgetDidBecomeReady:(FITAWebWidget *)widget
{
    NSLog(@"READY");

    self.loadButton.enabled = YES;
    self.loadButton.userInteractionEnabled = YES;

    [self.widget create:nil options:nil];
}

- (void)webWidgetInitialized:(FITAWebWidget *)widget
{
    NSLog(@"INIT");
}

- (void)webWidgetDidLoadProduct:(FITAWebWidget *)widget productId:(NSString *)productId details:(NSDictionary *)details {
    NSLog(@"LOAD event %@", productId);

    // We have all the info we need now - enable all buttons
    
    self.openButton.enabled = YES;
    self.openButton.userInteractionEnabled = YES;

    self.closeButton.enabled = YES;
    self.closeButton.userInteractionEnabled = YES;
    
    self.recommendButton.enabled = YES;
    self.recommendButton.userInteractionEnabled = YES;

    [self setMessage:(@"Loaded")];
}

- (void) webWidgetDidFailLoadingProduct:(FITAWebWidget *)widget productId:(NSString *)productId details:(NSDictionary *)details {
    NSLog(@"LOADERROR event %@", productId);
    
    // Unsupported product, disable all buttons
    
    self.openButton.enabled = NO;
    self.openButton.userInteractionEnabled = NO;
    
    self.closeButton.enabled = NO;
    self.closeButton.userInteractionEnabled = NO;
    
    self.recommendButton.enabled = NO;
    self.recommendButton.userInteractionEnabled = NO;

    [self setMessage:(@"Failed loading")];
}

- (void)webWidgetDidOpen:(FITAWebWidget *)widget productId:(NSString *)productId
{
    NSLog(@"OPEN event %@", productId);
   [self setMessage:(@"Opened")];
}

- (void)setRecommendedSize:(NSString *)size {
    [self setMessage:[NSString stringWithFormat:@"Size: %@", size]];
}

- (void)webWidgetDidClose:(FITAWebWidget *)widget productId:(NSString *)productId size:(NSString *)size details:(NSDictionary *)details
{
    NSLog(@"CLOSE event %@, %@", productId, size);
    [self setRecommendedSize:size];
}

- (void)webWidgetDidRecommend:(FITAWebWidget *)widget productId:(NSString *)productId size:(NSString *)size details:(NSDictionary *)details
{
    NSLog(@"RECOMMEND event %@, %@", productId, size);
    [self setRecommendedSize:size];
}

@end
