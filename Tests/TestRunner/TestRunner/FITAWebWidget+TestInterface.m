//
//  FITAWebWidget+TestInterface.m
//  FitAnalytics-WebWidget-SDK
//
//  Created by FitAnalytics on 16/12/16.
//  Copyright © 2016 FitAnalytics. All rights reserved.
//

@import PromiseKit;

#import "FITAWebWidget+TestInterface.h"

static NSString *const driverSource = @"\
window.__driver = {\
/* helpers */\
    $: FitAnalyticsWidget.jQuery,\
    works: function () { return true },\
    compileRefSelector: function (selector) {\
        var parts = (selector || '').split(/\\s+/);\
        parts.map(function (part) {\
            return part.charAt(0) == '@' ? '[data-ref=\"' + part.replace(/^@/, '') + '\"]' : part\
        }).join(' ')\
    },\
    getComponentByPath: function (path) {\
        Array.isArray(path) || (path = path.split('.'));\
        var out = window.__widgetManager.widget.screen;\
        for (var i = 0, n = path.length; i < n; i++) {\
            if (out == null) return;\
            out = out.children;\
            if (out == null) return;\
            out = out[path[i]];\
        }\
        return out;\
    },\
    click: function (sel) { this.$(sel).click() },\
    exists: function (sel) { this.$(sel).length > 0 },\
    getInputValueByRef: function (ref) {\
        return $(this.compileRefSelector(ref)).val()\
    },\
    setInputValueByRef: function (ref, value) {\
        var ref = compileRefSelector(ref);\
        this.click(ref).type(ref, value);\
    },\
    getComponentValue: function (path) {\
        var comp = this.getComponentByPath(path);\
        return comp.getValue();\
    },\
    setComponentValue: function (path, value) {\
        var comp = this.getComponentByPath(path);\
        return comp.setValue(value);\
    },\
    clickByRef: function (ref, value) { this.click(compileRefSelector(ref)) },\
    existsByRef: function (ref, value) { return this.exists(compileRefSelector(ref)) },\
\
/* tests */ \
    hasManager: function () { return !!window.__widgetManager },\
    hasWidget: function () { return window.__widgetManager && !!window.__widgetManager.widget },\
    isWidgetOpen: function () { return this.$(\"[data-ref='screen']\").length > 0 },\
    getScreenName: function () {\
        var screen = window.__widgetManager.widget.screen;\
        return screen != null ? (screen.name + (screen.options && screen.options.step ? screen.options.step : '')) : null\
    },\
    getDisplayedRecSP: function () {\
        var fp = this.$('#uclw_fit_prediction');\
        return {\
            size: this.$.trim(fp.find('h2').text()),\
            size0: this.$.trim(fp.find('.uclw_bar_top .uclw_label').text()),\
            size1: this.$.trim(fp.find('.uclw_bar_middle .uclw_label').text()),\
        }\
    },\
};\
";

@interface FITAWebWidget() <UIWebViewDelegate,WKNavigationDelegate>

@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, weak) WKWebView *wkWebView;

@end

typedef void (^EvalCallback)(id, NSError *);

static const EvalCallback noopFunction = ^(id result, NSError *error) {
    // NOOP
};

@implementation FITAWebWidget (TestInterface)

- (AnyPromise *)evaluateJavaScriptAsync:(NSString *)code
{
    FITAWebWidget *widget = self;
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve){
        [widget evaluateJavaScript:code done:^(id result, NSError *error) {
            resolve(error ? error : result);
        }];
    }];
}

- (AnyPromise *)initializeDriver
{
    return [self evaluateJavaScriptAsync:driverSource];
}

- (AnyPromise *)driverCall:(NSString *)name arguments:(NSArray *)arguments
{
    NSString *argsString = @"[]";

    if (arguments) {
        NSError* error = nil;
        NSData *argsData = [NSJSONSerialization dataWithJSONObject:arguments options:0 error:&error];
        if (!error) {
            argsString = [[NSString alloc] initWithData:argsData encoding:NSUTF8StringEncoding];
        }
    }
    NSString *code = [NSString stringWithFormat:@"window.__driver['%@'].apply(__driver, %@)", name, argsString];

    return [self evaluateJavaScriptAsync:code];
}

- (AnyPromise *)testHasManager {
    return [self driverCall:@"hasManager" arguments:nil];
}
- (AnyPromise *)testHasWidget {
    return [self driverCall:@"hasWidget" arguments:nil];
}
- (AnyPromise *)testIsWidgetOpen {
    return [self driverCall:@"isWidgetOpen" arguments:nil];
}
- (AnyPromise *)testGetScreenName {
    return [self driverCall:@"getScreenName" arguments:nil];
}
- (AnyPromise *)testGetInputValueByRef:(NSString *)ref {
    return [self driverCall:@"getInputValueByRef" arguments:@[ ref ]];
}
- (AnyPromise *)testSetInputValueByRef:(NSString *)ref value:(NSString *)value {
    return [self driverCall:@"setInputValueByRef" arguments:@[ ref, value ]];
}
- (AnyPromise *)testGetComponentValue:(NSString *)path {
    return [self driverCall:@"getComponentValue" arguments:@[ path ]];
}
- (AnyPromise *)testSetComponentValue:(NSString *)path value:(NSString *)value {
    return [self driverCall:@"setComponentValue" arguments:@[ path, value ]];
}
- (AnyPromise *)testGetHeight {
    return [self testGetComponentValue:@"form.height"];
}
- (AnyPromise *)testGetWeight {
    return [self testGetComponentValue:@"form.weight"];
}
- (AnyPromise *)testSetHeight:(NSString *)value {
    return [self testSetComponentValue:@"form.height" value:value];
}
- (AnyPromise *)testSetWeight:(NSString *)value {
    return [self testSetComponentValue:@"form.weight" value:value];
}
- (AnyPromise *)testSubmitBodyMassForm {
    return [self driverCall:@"click" arguments:@[ @".uclw_submit_form_button" ]];
}

@end
