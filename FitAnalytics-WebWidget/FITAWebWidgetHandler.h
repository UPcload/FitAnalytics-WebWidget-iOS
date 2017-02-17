//
//  FITAWebWidget.h
//  FitAnalytics-WebWidget-SDK
//
//  Created by FitAnalytics on 16/12/16.
//  Copyright © 2016 FitAnalytics. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FITAWebWidget;

NS_ASSUME_NONNULL_BEGIN

@protocol FITAWebWidgetHandler <NSObject>

/**
 * This method will be called when the widget container inside the WebView has successfully loaded
 * and is ready to accept commands.
 * @param widget The widget controller instance
 */
- (void)webWidgetDidBecomeReady:(FITAWebWidget *)widget;

/**
 * This method will be called when widget container inside the WebView has successfully loaded
 * and is ready to accept commands.
 * @param widget The widget controller instance
 */
@optional
- (void)webWidgetInitialized:(FITAWebWidget *)widget;

/**
 * This method will be called when widget inside the WebView has failed to load or initialize for some reason.
 * @param widget The widget controller instance
 */
@optional
- (void)webWidgetDidFailLoading:(FITAWebWidget *)widget withError:(NSError *)error;

/**
 * This method will be called when widget successfully loaded the product info.
 * It means the product is supported and the widget should be able to provide
 * a size recommendation for it.
 * @param widget The widget controller instance
 * @param productId The ID of the product
 * @param details The details object
 */
@optional
- (void)webWidgetDidLoadProduct:(FITAWebWidget *)widget productId:(NSString *)productId details:(NSDictionary *)details;

/**
 * This method will be called when widget failed to load the product info or the product is not supported.
 * @param widget The widget controller instance
 * @param productId The ID of the product
 * @param details The details object
 */
@optional
- (void)webWidgetDidFailLoadingProduct:(FITAWebWidget *)widget productId:(NSString *)productId details:(NSDictionary *)details;

/**
 * This method will be called when widget has successfully opened after the `open` method call.
 * @param widget The widget controller instance
 * @param productId The ID of the product
 */
@optional
- (void)webWidgetDidOpen:(FITAWebWidget *)widget productId:(NSString *)productId;

/**
 * This method will be called when user of the widget has specifically requested closing of the widget by clicking on the close button.
 * @param widget The widget controller instance
 * @param productId The ID of the product
 * @param size The recommended size of the product, if there was a recommendation. `null` if there wasn't any recommendation
 * @param details The details object.
 */
@optional
- (void)webWidgetDidClose:(FITAWebWidget *)widget productId:(NSString *)productId size:(NSString *)size details:(NSDictionary *)details;

/**
 * This method will be called when user of the widget has specifically clicked on the add-to-cart inside the widget.
 * @param widget The widget controller instance
 * @param productId The ID of the product
 * @param size The recommended size of the product, if there was a recommendation. `null` if there wasn't any recommendation
 * @param details The details object.
 */
@optional
- (void)webWidgetDidAddToCart:(FITAWebWidget *)widget productId:(NSString *)productId size:(NSString *)size details:(NSDictionary *)details;

/**
 * This method will be called after the `getRecommendation` call on the FITAWebWidget controller, when the widget has received and processed the size recommendation.
 * @param productId The ID of the product
 * @param size The recommended size of the product, if there was a recommendation. `null` if there wasn't any recommendation.
 * @param details The details object.
 */
@optional
- (void)webWidgetDidRecommend:(FITAWebWidget *)widget productId:(NSString *)productId size:(NSString *)size details:(NSDictionary *)details;

@end

NS_ASSUME_NONNULL_END
