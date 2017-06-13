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

#import "FITAWebWidget.h"

@interface FITAWebWidget (TestInterface)

- (NSString *)evalJavascript:(NSString *)code;
- (NSString *)initializeDriver;
- (NSString *)driverCall:(NSString *)name arguments:(NSArray *)arguments;

- (NSString *)testHasManager;
- (NSString *)testHasWidget;
- (NSString *)testIsWidgetOpen;
- (NSString *)testGetScreenName;
- (NSString *)testGetHeight;
- (NSString *)testGetWeight;
- (NSString *)testSetHeight:(NSString *)value;
- (NSString *)testSetWeight:(NSString *)value;
- (NSString *)testSubmitBodyMassForm;

@end

#endif /* FITAWebWidget_TestInterface_h */
