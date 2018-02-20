//
//  FITAPurchaseReport.h
//  FitAnalytics-WebWidget-SDK
//
//  Created by FitAnalytics on 2017-11-02.
//  Copyright © 2017 FitAnalytics. All rights reserved.
//

#ifndef FITAPurchaseReport_h
#define FITAPurchaseReport_h

NS_ASSUME_NONNULL_BEGIN

@interface FITAPurchaseReport : NSObject

@property (nonatomic, nullable) NSString *productSerial;
@property (nonatomic, nullable) NSString *shopArticleCode;
@property (nonatomic, nullable) NSString *userId;
@property (nonatomic, nullable) NSString *purchasedSize;
@property (nonatomic, nullable) NSString *orderId;
@property (nonatomic, nullable) NSString *price;
@property (nonatomic, nullable) NSString *currency;
@property (nonatomic, nullable) NSString *sizeRegion;
@property (nonatomic, nullable) NSString *shop;
@property (nonatomic, nullable) NSString *shopCountry;
@property (nonatomic, nullable) NSString *shopLanguage;
@property (nonatomic, nullable) NSString *shopSizingSystem;
@property (nonatomic, nullable) NSString *ean;
@property (nonatomic, nullable) NSString *funnel;
@property (nonatomic, nullable) NSString *sid;
@property (nonatomic, nullable) NSString *hostname;

/**
 * Initialize empty
 */
- (instancetype)init;

/**
 * Initialize with a dictionary
 */
- (instancetype)initWithDictionary:(nonnull NSDictionary *)attrs;

@end

NS_ASSUME_NONNULL_END

#endif /* FITAPurchaseReport_h */
