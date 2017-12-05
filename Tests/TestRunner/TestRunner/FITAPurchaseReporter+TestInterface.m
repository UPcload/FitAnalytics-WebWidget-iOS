//
//  FITAPurchaseReporter+TestInterface.m
//  TestRunner
//
//  Copyright © 2017 FitAnalytics. All rights reserved.
//

#import <Foundation/Foundation.h>

@import PromiseKit;

#import "FITAPurchaseReporter+TestInterface.h"

@interface FITAPurchaseReporter()
@end

@implementation FITAPurchaseReporter (TestInterface)

- (AnyPromise *)sendReportAsync:(FITAPurchaseReport *)report
{
    FITAPurchaseReporter *reporter = self;
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve){
        [reporter sendReport:report done:^(NSError *error) {
            resolve(error ? error : NULL);
        }];
    }];
}

@end
