//
//  FITAPurchaseReporter.h
//  FitAnalytics-WebWidget-SDK
//
//  Created by FitAnalytics on 2017-11-02.
//  Copyright © 2017 FitAnalytics. All rights reserved.
//


#ifndef FITAPurchaseReporter_h
#define FITAPurchaseReporter_h

#import <Foundation/Foundation.h>

#import "FITAPurchaseReport.h"


NS_ASSUME_NONNULL_BEGIN

@interface FITAPurchaseReporter : NSObject

/**
 * Initialize
 */
- (instancetype)init;

- (BOOL)sendReport:(FITAPurchaseReport *)report;
- (BOOL)sendReport:(FITAPurchaseReport *)report completionHandler:(nullable void (^)(NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END

#endif /* FITAPurchaseReporter_h */
