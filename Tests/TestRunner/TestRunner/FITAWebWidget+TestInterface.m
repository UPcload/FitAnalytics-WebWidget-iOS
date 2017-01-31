//
//  FITAWebWidget+TestInterface.m
//  FitAnalytics-WebWidget-SDK
//
//  Created by FitAnalytics on 16/12/16.
//  Copyright © 2016 FitAnalytics. All rights reserved.
//

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

@implementation FITAWebWidget (TestInterface)

- (NSString *)initializeDriver
{
    return [self evalJavascript:driverSource];
}

- (NSString *)driverCall:(NSString *)name arguments:(NSArray *)arguments
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
    return [self evalJavascript:code];
}

- (NSString *)testHasManager {
    return [self driverCall:@"hasManager" arguments:nil];
}
- (NSString *)testHasWidget {
    return [self driverCall:@"hasWidget" arguments:nil];
}
- (NSString *)testIsWidgetOpen {
    return [self driverCall:@"isWidgetOpen" arguments:nil];
}
- (NSString *)testGetScreenName {
    return [self driverCall:@"getScreenName" arguments:nil];
}
- (NSString *)testGetInputValueByRef:(NSString *)ref {
    return [self driverCall:@"getInputValueByRef" arguments:@[ ref ]];
}
- (NSString *)testSetInputValueByRef:(NSString *)ref value:(NSString *)value {
    return [self driverCall:@"setInputValueByRef" arguments:@[ ref, value ]];
}
- (NSString *)testGetComponentValue:(NSString *)path {
    return [self driverCall:@"getComponentValue" arguments:@[ path ]];
}
- (NSString *)testSetComponentValue:(NSString *)path value:(NSString *)value {
    return [self driverCall:@"setComponentValue" arguments:@[ path, value ]];
}
- (NSString *)testGetHeight {
    return [self testGetComponentValue:@"form.height"];
}
- (NSString *)testGetWeight {
    return [self testGetComponentValue:@"form.weight"];
}
- (NSString *)testSetHeight:(NSString *)value {
    return [self testSetComponentValue:@"form.height" value:value];
}
- (NSString *)testSetWeight:(NSString *)value {
    return [self testSetComponentValue:@"form.weight" value:value];
}
- (NSString *)testSubmitBodyMassForm {
    return [self driverCall:@"click" arguments:@[ @".uclw_submit_form_button" ]];
}

@end
