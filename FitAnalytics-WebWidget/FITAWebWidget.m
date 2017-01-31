//
//  FITAWebWidget.h
//  FitAnalytics-WebWidget-SDK
//
//  Created by FitAnalytics on 16/12/16.
//  Copyright © 2016 FitAnalytics. All rights reserved.
//

#import "FITAWebWidget.h"
#import "FITAWebWidgetHandler.h"
#import <netinet/in.h>

// the default widget container page
static NSString *const kWidgetURLString = @"https://widget.fitanalytics.com/widget/app-embed.html";

// the custom protocol prefix
static NSString *const kUriPrefix = @"fita:";

typedef void (^WidgetEventCallback)(FITAWebWidget *);

// FITAWebWidget class extension to hide members
@interface FITAWebWidget() <UIWebViewDelegate>

@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, strong) id<FITAWebWidgetHandler> handler;
@property BOOL isLoading;
@property BOOL isLoaded;
@property (nonatomic, strong) WidgetEventCallback onLoadCallback;

@end

@implementation FITAWebWidget

/**
 * Initialize the controller with WebView instance and the callback handler
 * @param webView The WebView instance that will contain the load widget container page
 * @param handler The handler contains callbacks that are invoked by the widget
 */
- (instancetype)initWithWebView:(UIWebView *)webView handler:(id<FITAWebWidgetHandler>)handler
{
    NSParameterAssert(webView);
    NSParameterAssert(handler);

    if (self = [super init]) {
        _webView = webView;
        _webView.delegate = self;
        _handler = handler;
        _isLoading = NO;
        _isLoaded = NO;
    }

    return self;
}

#pragma mark - JS-to-iOS communication -

/**
 * Decode and deserialize incoming message.
 * @param  {NSString *encodedMessage} Base64-encoded JSON object
 * @return {NSDictionary *} Resulting NSDictionary representation of the JSON inside the messager
 */
- (NSDictionary *)decodeMessage:(NSString *)encodedMessage
{
    // decode base64
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:encodedMessage options:0];
    NSString *message = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];

    // decode JSON to dictionary
    NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    return parsedData;
}

/**
 * Decode and dispatch the incoming widget event message
 * to corresponding event handlers
 * @param {NSString *} encodedMessage Incoming base64-encoded message
 */
- (void)receiveMessage:(NSString *)encodedMessage
{
    NSDictionary *message = [self decodeMessage:encodedMessage];
    
    NSString *action = [message valueForKey:@"action"];
    NSArray *arguments = [message valueForKey:@"arguments"];

    if (action != nil) {
        if ([action isEqualToString:@"__ready"]) {
            self.isLoaded = YES;
            self.isLoading = NO;
            if ([self.handler respondsToSelector:@selector(webWidgetDidBecomeReady:)]) {
                [self.handler webWidgetDidBecomeReady:self];
            }
        }
        else if ([action isEqualToString:@"__init"]) {
            if ([self.handler respondsToSelector:@selector(webWidgetInitialized:)]) {
                [self.handler webWidgetInitialized:self];
            }
        }
        else if ([action isEqualToString:@"load"]) {
            if (arguments != nil && [self.handler respondsToSelector:@selector(webWidgetDidLoadProduct:productId:details:)]) {
                NSString *productId = [arguments objectAtIndex:0];
                NSDictionary *details = [arguments objectAtIndex:1];
                [self.handler webWidgetDidLoadProduct:self productId:productId details:details];
            } 
        }
        else if ([action isEqualToString:@"error"]) {
            if (arguments != nil && [self.handler respondsToSelector:@selector(webWidgetDidFailLoadingProduct:productId:details:)]) {
                NSString *productId = [arguments objectAtIndex:0];
                NSDictionary *details = [arguments objectAtIndex:1];
                [self.handler webWidgetDidFailLoadingProduct:self productId:productId details:details];
            }
        }
        else if ([action isEqualToString:@"open"]) {
            if (arguments != nil && [self.handler respondsToSelector:@selector(webWidgetDidOpen:productId:)]) {
                NSString *productId = [arguments objectAtIndex:0];
                [self.handler webWidgetDidOpen:self productId:productId];
            }
        }
        else if ([action isEqualToString:@"close"]) {
            if (arguments != nil && [self.handler respondsToSelector:@selector(webWidgetDidRecommend:productId:size:details:)]) {
                NSString *productId = [arguments objectAtIndex:0];
                NSString *size = [arguments objectAtIndex:1];
                NSDictionary *details = [arguments objectAtIndex:2];
                [self.handler webWidgetDidClose:self productId:productId size:size details:details];
            }
        }
        else if ([action isEqualToString:@"cart"]) {
            if (arguments != nil && [self.handler respondsToSelector:@selector(webWidgetDidAddToCart:productId:size:details:)]) {
                NSString *productId = [arguments objectAtIndex:0];
                NSString *size = [arguments objectAtIndex:1];
                NSDictionary *details = [arguments objectAtIndex:2];
                [self.handler webWidgetDidAddToCart:self productId:productId size:size details:details];
            }
        }
        else if ([action isEqualToString:@"recommend"]) {
            if (arguments != nil && [self.handler respondsToSelector:@selector(webWidgetDidRecommend:productId:size:details:)]) {
                NSString *productId = [arguments objectAtIndex:0];
                NSString *size = [arguments objectAtIndex:1];
                NSDictionary *details = [arguments objectAtIndex:2];
                [self.handler webWidgetDidRecommend:self productId:productId size:size details:details];
            }
        }
    }
}

#pragma mark - iOS-to-JS communication -

- (NSString *)encodeMessage:(NSDictionary *)message
{
    // encode dictionary to JSON
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:message options:0 error:&error];

    if (error) {
        return nil;
    }

    // encode JSON string to base64
    NSString *encodedString = [jsonData base64EncodedStringWithOptions:0];

    return encodedString;
}

- (BOOL)sendMessage:(NSDictionary *)message
{
    NSString *encodedMessage = [self encodeMessage:message];
    if (!encodedMessage) {
        return NO;
    }
    NSString *code = [NSString stringWithFormat:@"window.__widgetManager.receiveMessage('%@');", encodedMessage];
    [self.webView stringByEvaluatingJavaScriptFromString:code];
    return YES;
}

/**
 * Utility method for compiling and sending action message to the widget.
 * All actions are composed of an action name (e.g. "open") and an array of arguments.
 * The widget controller inside the container page accepts several pre-defined actions.
 * @param {NSString *}action 
 */
- (BOOL)createAndSendAction:(NSString *)action withArguments:(NSArray *)arguments
{
    NSDictionary *message = @{
        @"action": action,
        @"arguments": arguments
    };

    return [self sendMessage:message];
}

- (NSMutableDictionary *)cloneAndExtendArguments:(NSDictionary *)arguments extendArguments:(NSDictionary *)extendArguments
{
    if (!arguments) {
        arguments = @{};
    }
    NSMutableDictionary *out = [arguments mutableCopy];
    for (id key in extendArguments) {
        id value = [extendArguments objectForKey:key];
        [out setValue:value forKey:key];
    }
    return out;
}

/**
 * Prepares the `options` argument that's expected by several widget methods
 * by merging `productSerial` (if present) into the `options` dictionary (if present).  
 * @param productSerial (optional) Product serial
 * @param options (optional) Additional widget options
 * @return Resulting merged dictionary
 */
- (NSDictionary *)createWidgetOptions:(NSString *)productSerial options:(NSDictionary *)options
{
    NSDictionary *arguments;
    NSDictionary *defaultArguments = @{
       @"showMobile": @1,
       @"forceVersion": @"mobile",
       @"open": @YES
    };

    if (productSerial) {
        NSDictionary *productArguments =  @{
            @"productSerial": productSerial,
        };
        if (options) {
            arguments = [self cloneAndExtendArguments:options extendArguments:productArguments];
        } else {
            arguments = productArguments;
        }
    } else {
        arguments = options ? options : @{};
    }
    arguments = [self cloneAndExtendArguments:defaultArguments extendArguments:arguments];
    
    return arguments;
}

#pragma mark - Public API -

/**
 * Load the widget container page
 */
- (BOOL)load
{
    if (!self.isLoading) {
        self.isLoading = YES;
        NSURL *widgetURL = [NSURL URLWithString:kWidgetURLString];
        NSURLRequest *widgetURLRequest = [NSURLRequest requestWithURL:widgetURL];
        [self.webView loadRequest:widgetURLRequest];
        return YES;
    } else {
        return NO;
    }
}


- (BOOL)create:(nullable NSString *)productSerial options:(nullable NSDictionary *)options
{
    if (self.isLoading) {
        return NO;
    }

    // if the widget isn't loaded yet, try loading it and call
    // the "init" after it's loaded (via closure)

    WidgetEventCallback cb = ^(FITAWebWidget *widget) {
        [widget createAndSendAction:@"init" withArguments:@[
            [widget createWidgetOptions:productSerial options:options]
        ]];
    };

    if (!self.isLoaded) {
        self.onLoadCallback = cb;
        [self load];
    } else {
        cb(self);
    }

    return YES;
}

- (void)open
{
    [self createAndSendAction:@"open" withArguments:@[ @{} ]];  
}

- (void)openWithOptions:(nullable NSString *)productSerial options:(nullable NSDictionary *)options
{
    [self createAndSendAction:@"open" withArguments:@[
        [self createWidgetOptions:productSerial options:options]
    ]];
}

- (void)close
{
    [self createAndSendAction:@"close" withArguments:@[ @{} ]];  
}

- (void)reconfigure:(nullable NSString *)productSerial options:(nullable NSDictionary *)options
{
    [self createAndSendAction:@"reconfigure" withArguments:@[
        [self createWidgetOptions:productSerial options:options]
    ]];
}

- (void)recommend
{
    [self createAndSendAction:@"getRecommendation" withArguments:@[ @{} ]];
}

- (void)recommendWithOptions:(nullable NSString *)productSerial options:(nullable NSDictionary *)options
{
    [self createAndSendAction:@"getRecommendation" withArguments:@[
        [self createWidgetOptions:productSerial options:options]
    ]];
}

#pragma mark - UIWebViewDelegate -

// JS-to-iOS bridge via custom URI schema
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *uri = [[request URL] absoluteString];

    if ([uri hasPrefix:kUriPrefix]) {
        NSString *message = [uri stringByReplacingOccurrencesOfString:kUriPrefix withString:@""];
        [self receiveMessage:message];
        return NO;
    }
    else {
        return YES;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.isLoading = YES;
    self.isLoaded = YES;

    if (self.onLoadCallback) {
        self.onLoadCallback(self);
        self.onLoadCallback = nil;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.isLoading = NO;
    self.isLoaded = NO;

    if ([self.handler respondsToSelector:@selector(webWidgetDidFailLoading:withError:)]) {
        [self.handler webWidgetDidFailLoading:self withError:error];
    }
}

@end
