//
//  FITAPurchaseReporter.m
//  FitAnalytics-WebWidget-SDK
//
//  Created by FitAnalytics on 2017-11-02.
//  Copyright © 2017 FitAnalytics. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FITAPurchaseReport.h"

@implementation FITAPurchaseReport

- (instancetype)init
{
    if (self = [super init]) {
    }

    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)attrs
{
    NSString *value;

    if (self = [super init]) {
        if ((value = [attrs valueForKey:@"productSerial"]) != nil)
            self.productSerial = value;
        if ((value = [attrs valueForKey:@"shopArticleCode"]) != nil)
            self.shopArticleCode = value;
        if ((value = [attrs valueForKey:@"userId"]) != nil)
            self.userId = value;
        if ((value = [attrs valueForKey:@"purchasedSize"]) != nil)
            self.purchasedSize = value;
        if ((value = [attrs valueForKey:@"orderId"]) != nil)
            self.orderId = value;
        if ((value = [attrs valueForKey:@"price"]) != nil)
            self.price = value;
        if ((value = [attrs valueForKey:@"currency"]) != nil)
            self.currency = value;
        if ((value = [attrs valueForKey:@"sizeRegion"]) != nil)
            self.sizeRegion = value;
        if ((value = [attrs valueForKey:@"shop"]) != nil)
            self.shop = value;
        if ((value = [attrs valueForKey:@"shopCountry"]) != nil)
            self.shopCountry = value;
        if ((value = [attrs valueForKey:@"shopLanguage"]) != nil)
            self.shopLanguage = value;
        if ((value = [attrs valueForKey:@"shopSizingSystem"]) != nil)
            self.shopSizingSystem = value;
        if ((value = [attrs valueForKey:@"ean"]) != nil)
            self.ean = value;
        if ((value = [attrs valueForKey:@"funnel"]) != nil)
            self.funnel = value;
        if ((value = [attrs valueForKey:@"sid"]) != nil)
            self.sid = value;
        if ((value = [attrs valueForKey:@"hostname"]) != nil)
            self.hostname = value;
    }

    return self;
}

@end
