//
//  ViewController.h
//  Framework Example
//
//  Copyright © 2018 FitAnalytics. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FitAnalytics_WebWidget/FITAWebWidget.h>
#import <FitAnalytics_WebWidget/FITAWebWidgetHandler.h>

@interface ViewController : UIViewController

@property (strong, nonatomic, nullable) UIWebView *webView;
@property (nonatomic, strong, nullable) FITAWebWidget *widget;

@end

