//
//  FITAWebWidget.h
//  FitAnalytics-WebWidget-SDK
//
//  Created by FitAnalytics on 16/12/16.
//  Copyright © 2016 FitAnalytics. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FITAWebWidgetHandler;

NS_ASSUME_NONNULL_BEGIN

@interface FITAWebWidget : NSObject

/**
 * Initialize webview and assign the callback handler
 */
- (instancetype)initWithWebView:(UIWebView *)webView handler:(id<FITAWebWidgetHandler>)handler;

/**
 * Load the HTML widget container page.
 */
- (BOOL)load;

/**
 * Create the widget with a product serial and/or widget options
 * Must be called after the -[FITAWebWidgetHandler onWebWidgetDidBecomeReady] callback
 */
- (BOOL)create:(nullable NSString *)productSerial options:(nullable NSDictionary *)options;

/**
 * Show the actual widget. When the widget finishes opening, it will call the
 * -[FITAWebWidgetHandler onWebWidgetDidOpen] callback
 */
- (void)open;

/**
 * Show the actual widget, see -[FITAWebWidget open].
 * Allows passing new product serial and/or widget options object.
 * @param productSerial (optional) The new product serial
 * @param options (optional) Additional widget options 
 */
- (void)openWithOptions:(nullable NSString *)productSerial options:(nullable NSDictionary *)options;

/**
 * Close the widget. Removes the widget markup and event handlers, potentially 
 * freeing up some memory.
 */
- (void)close;

/**
 * Reconfigure the widget with a new product serial and/or widget options object.
 * @param productSerial (optional) The new product serial
 * @param options (optional) Widget options 
 */
- (void)reconfigure:(nullable NSString *)productSerial options:(nullable NSDictionary *)options;

/**
 * Request a recommendation. The recommended size will be returned as an argument to
 * the -[FITAWebWidgetHandler onWebWidgetDidRecommend] callback
 */
- (void)recommend;

/**
 * Request a recommendation, see -[FITAWebWidget recommend].
 * Allows passing new product ID and/or widget options object.
 * @param productSerial (optional) The new product serial
 * @param options (optional) Additional widget options 
 */
- (void)recommendWithOptions:(nullable NSString *)productSerial options:(nullable NSDictionary *)options;

@end

NS_ASSUME_NONNULL_END
