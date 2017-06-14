//
//  ViewController.h
//  TestRunner
//
//  Created by FitAnalytics on 30/01/17.
//  Copyright © 2017 FitAnalytics. All rights reserved.
//

#import <UIKit/UIKit.h>
@import PromiseKit;

#import "FITAWebWidget+TestInterface.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) FITAWebWidget *widget;

- (FITAWebWidget *)initializeWidget;
- (AnyPromise *)widgetLoad;

@end

