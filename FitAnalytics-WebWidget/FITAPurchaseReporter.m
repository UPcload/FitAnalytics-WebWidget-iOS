//
//  FITAPurchaseReporter.m
//  FitAnalytics-WebWidget-SDK
//
//  Created by FitAnalytics on 2017-11-02.
//  Copyright © 2017 FitAnalytics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <netinet/in.h>

#import "FITAPurchaseReport.h"
#import "FITAPurchaseReporter.h"

// the default widget container page
static NSString *const kReportUrl0 = @"https://collector.fitanalytics.com/purchases";
static NSString *const kReportUrl1 = @"https://collector-de.fitanalytics.com/purchases";

static NSString *const kSidKey = @"com.fitanalytics.widget.sid";


@interface FITAPurchaseReporter()

@property (nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation FITAPurchaseReporter

- (instancetype)init
{
    if (self = [super init]) {
        _defaults = [[NSUserDefaults alloc] init];
    }

    return self;
}

- (BOOL)sendReport:(FITAPurchaseReport *)report completionHandler:(void (^)(NSError * _Nullable))completionHandler
{
    NSDictionary *processedReport = [self processReport:report];
    if (!processedReport) {
        return NO;
    }

    NSString *urlString0 = [self buildUrlString:kReportUrl0 attrs:processedReport];
    NSString *urlString1 = [self buildUrlString:kReportUrl1 attrs:processedReport];

    [self sendRequest:urlString0 done:completionHandler];
    [self sendRequest:urlString1 done:nil];

    return YES;
}

- (BOOL)sendReport:(FITAPurchaseReport *)report
{
    return [self sendReport:report completionHandler:nil];
}

- (NSDictionary *)processReport:(FITAPurchaseReport *)report 
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSString *value;

    if ((value = report.productSerial) != nil)
        [dict setValue:value forKey:@"productId"]; // productSerial is sent as "productId"
    if ((value = report.shopArticleCode) != nil)
        [dict setValue:value forKey:@"variantId"]; // shopArticleCode is sent as "variantId"
    if ((value = report.userId) != nil)
        [dict setValue:value forKey:@"userId"];
    if ((value = report.purchasedSize) != nil)
        [dict setValue:value forKey:@"purchasedSize"];
    if ((value = report.orderId) != nil)
        [dict setValue:value forKey:@"orderId"];
    if ((value = report.price) != nil)
        [dict setValue:value forKey:@"price"];
    if ((value = report.currency) != nil)
        [dict setValue:value forKey:@"currency"];
    if ((value = report.sizeRegion) != nil)
        [dict setValue:value forKey:@"sizeRegion"];
    if ((value = report.shop) != nil)
        [dict setValue:value forKey:@"shop"];
    if ((value = report.shopCountry) != nil)
        [dict setValue:value forKey:@"shopCountry"];
    if ((value = report.shopLanguage) != nil)
        [dict setValue:value forKey:@"shopLanguage"];
    if ((value = report.shopSizingSystem) != nil)
        [dict setValue:value forKey:@"shopSizingSystem"];
    if ((value = report.ean) != nil)
        [dict setValue:value forKey:@"ean"];
    if ((value = report.funnel) != nil)
        [dict setValue:value forKey:@"funnel"];
    if ((value = report.hostname) != nil)
        [dict setValue:value forKey:@"hostname"];

    NSString *sid = nil;
    if (report.sid != nil)
        sid = report.sid;
    else
        sid = [_defaults objectForKey:kSidKey];

    if (sid != nil && [sid isKindOfClass:[NSString class]])
        [dict setValue:sid forKey:@"sid"];

    [dict setValue:@"callback" forKey:@"sender"];
    [dict setValue:@"embed-ios" forKey:@"hostname"];

    NSDate *currentDate = [NSDate date];
    long long intervalMS = floor([currentDate timeIntervalSince1970] * 1000);
    [dict setValue:[NSString stringWithFormat:@"%lld", intervalMS] forKey:@"timeStamp"];

    return dict;
}

- (NSString *)buildQueryPart:(NSString *)key value:(NSString *)value
{
    NSString *encodedValue = [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    // keys are already url-safe, no need to encode them
    return [NSString stringWithFormat:@"%@=%@", key, encodedValue];
}

- (NSString *)buildUrlString:(NSString *)serverUrl attrs:(NSDictionary *)attrs
{
    NSMutableArray *parts = [[NSMutableArray alloc] init];

    for (id key in attrs) {
        id value = [attrs objectForKey:key];
        [parts addObject:[self buildQueryPart:key value:value]];
    }

    NSString *query = [parts componentsJoinedByString: @"&"];

    return [NSString stringWithFormat:@"%@?%@", serverUrl, query];
}

- (BOOL)sendRequest:(NSString *)urlString done:(void (^)(NSError * _Nullable))done
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];

    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (done != nil) {
            done(error);
        }
    }] resume];

    return YES;
}

@end
