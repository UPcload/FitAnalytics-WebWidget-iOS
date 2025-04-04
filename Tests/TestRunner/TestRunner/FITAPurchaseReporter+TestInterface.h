//
//  FITAPurchaseReporter+TestInterface.h
//  TestRunner
//
//  Created by Tomas Jelen on 09/11/2017.
//  Copyright © 2017 FitAnalytics. All rights reserved.
//

#ifndef FITAPurchaseReporter_TestInterface_h
#define FITAPurchaseReporter_TestInterface_h

#import <Foundation/Foundation.h>
#import "FITAPurchaseReporter.h"

@import PromiseKit;

@interface FITAPurchaseReporter (TestInterface)

// promisified sendReport method
- (AnyPromise *)sendReportAsync:(FITAPurchaseReport *)report;

@end


#endif /* FITAPurchaseReporter_TestInterface_h */
