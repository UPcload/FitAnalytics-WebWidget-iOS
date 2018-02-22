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

#pragma mark - Public API -

- (instancetype)init
{
    if (self = [super init]) {
    }

    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)attrs
{
    NSString *value;
    NSDecimalNumber *price;

    if (self = [super init]) {
        if ((value = [attrs valueForKey:@"productSerial"]) != nil && [self isValueString:(value)])
            self.productSerial = value;
        if ((value = [attrs valueForKey:@"shopArticleCode"]) != nil && [self isValueString:(value)])
            self.shopArticleCode = value;
        if ((value = [attrs valueForKey:@"userId"]) != nil && [self isValueString:(value)])
            self.userId = value;
        if ((value = [attrs valueForKey:@"purchasedSize"]) != nil && [self isValueString:(value)])
            self.purchasedSize = value;
        if ((value = [attrs valueForKey:@"orderId"]) != nil && [self isValueString:(value)])
            self.orderId = value;
        if ((price = [attrs valueForKey:@"price"]) != nil && [self isValueDecimal:(price)])
            self.price = price;
        if ((value = [attrs valueForKey:@"currency"]) != nil && [self isValueString:(value)])
            self.currency = value;
        if ((value = [attrs valueForKey:@"sizeRegion"]) != nil && [self isValueString:(value)])
            self.sizeRegion = value;
        if ((value = [attrs valueForKey:@"shop"]) != nil && [self isValueString:(value)])
            self.shop = value;
        if ((value = [attrs valueForKey:@"shopCountry"]) != nil && [self isValueString:(value)])
            self.shopCountry = value;
        if ((value = [attrs valueForKey:@"shopLanguage"]) != nil && [self isValueString:(value)])
            self.shopLanguage = value;
        if ((value = [attrs valueForKey:@"shopSizingSystem"]) != nil && [self isValueString:(value)])
            self.shopSizingSystem = value;
        if ((value = [attrs valueForKey:@"ean"]) != nil && [self isValueString:(value)])
            self.ean = value;
        if ((value = [attrs valueForKey:@"funnel"]) != nil && [self isValueString:(value)])
            self.funnel = value;
        if ((value = [attrs valueForKey:@"sid"]) != nil && [self isValueString:(value)])
            self.sid = value;
    }

    return self;
}

#pragma mark - Preprocessing helpers -

- (BOOL)isValueString:(id)value
{
    return [value isKindOfClass:[NSString class]];
}

- (BOOL)isValueDecimal:(id)value
{
    return [value isKindOfClass:[NSDecimalNumber class]];
}

@end
