//
//  FITAPurchaseReport.h
//  FitAnalytics-WebWidget-SDK
//
//  Created by FitAnalytics on 2017-11-02.
//  Copyright © 2017 FitAnalytics. All rights reserved.
//

#ifndef FITAPurchaseReport_h
#define FITAPurchaseReport_h

@interface FITAPurchaseReport : NSObject

@property (nonatomic) NSString *productSerial;
@property (nonatomic) NSString *shopArticleCode;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *purchasedSize;
@property (nonatomic) NSString *orderId;
@property (nonatomic) NSString *price;
@property (nonatomic) NSString *currency;
@property (nonatomic) NSString *sizeRegion;
@property (nonatomic) NSString *shop;
@property (nonatomic) NSString *shopCountry;
@property (nonatomic) NSString *shopLanguage;
@property (nonatomic) NSString *shopSizingSystem;
@property (nonatomic) NSString *ean;
@property (nonatomic) NSString *funnel;
@property (nonatomic) NSString *sid;
@property (nonatomic) NSString *hostname;

/**
 * Initialize empty
 */
- (instancetype)init;

/**
 * Initialize with a dictionary
 */
- (instancetype)initWithDictionary:(NSDictionary *)attrs;

@end

#endif /* FITAPurchaseReport_h */
