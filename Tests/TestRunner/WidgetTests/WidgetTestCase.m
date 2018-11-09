//
//  WidgetTestCase.m
//  TestRunner
//
//  Created by FitAnalytics on 13/06/2017.
//  Copyright © 2017 FitAnalytics. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WidgetTestCase.h"

#import "AppDelegate.h"
#import "ViewController.h"
#import "FITAWebWidget+TestInterface.h"

@implementation WidgetTestCase

- (void)setUp {
    [super setUp];
}

- (void)initContext {
    UIApplication *uiapp = [UIApplication sharedApplication];
    AppDelegate *delegate = (AppDelegate *)[uiapp delegate];
    viewController = (ViewController *)delegate.initialViewController;
    widget = [viewController initializeWidget];
}

- (AnyPromise *)makeRequestAsync:(NSString *)path {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve){
      NSString *host = [[[NSProcessInfo processInfo] environment] objectForKey:@"NETHOOKS_HOST"];

      NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", host, path]];
      NSURLSession *session = [NSURLSession sharedSession];
      NSLog(@"URL %@", url);

      [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
          resolve(error ? error : [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
      }] resume];
    }];
}

- (BOOL)isNethooksConfigured {
    NSString *host = [[[NSProcessInfo processInfo] environment] objectForKey:@"NETHOOKS_HOST"];
    return host != nil;
}

@end
