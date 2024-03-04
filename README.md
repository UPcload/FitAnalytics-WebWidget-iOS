# FitAnalytics WebWidget Integration in iOS (Objective-C)

## Overview

The WebWidget SDK allows integrating the Fit Analytics Size Advisor widget into your own iOS app.

As a first step, we suggest that you familiarize yourself with the Fit Analytics web-based Size Advisor service by:  
1. Reading through the Fit Analytics website and trying out a sample product - https://www.fitanalytics.com/  

The integration method currently supported by this SDK is based on loading HTML/JS-based widget code in a separate WKWebView instance and establishing communication between the host app and the embedded web widget.  

The SDK introduces a layer that imitates a web-based (JavaScript) integration of the Fit Analytics widget by:  
1. Exporting the **FitAWebWidget** class, which serves as a main widget controller.   
2. Creating and initializing the widget in a provided web view instance.  
3. Exposing several methods that allow controlling the widget.  
4. Defining the **FITAWebWidgetHandler** interface, which allows registering various callbacks (by implementing them as interface methods). These callbacks are invoked by the widget controller through various events (e.g. when a user closes the widget, when the widget displays a recommendation,   etc.).  

Preferably, you can also include the purchase reporting for the order confirmation page/view.

---

## Installation (using Cocoapods)

**Prerequisities:** 
1. XCode 7 or higher  
2. iOS 9 or higher  

**Step 1.** Make sure you already have cocoapods installed in your system. Otherwise you can follow the steps in cocoapods documentation to install
https://cocoapods.org/

**Step 2.** To initialize the pod in your project use `pod init` command to create a Podfile with smart defaults.

**Step 3.** Now you can install the dependencies in your project by using `pod install` command.

**Step 4.** Make sure you always open **Xcode Workspace** instead of Xcode Project. You can do it by
using **open YourApp.xcworkspace** command in terminal.

## Installation (using the universal binary framework)

Alternatively you can use the pre-built universal binary framework. It's available for download with each release (since v0.4.2). 

It comes in two build flavors: 
   1) **all** - which includes binary code for both devices (arm7x, arm64) and simulators (i386, x86_64)
   2) **device_only** - which includes just device-specific binaries (arm7x, arm64). The device-specific flavor is meant for final builds that are meant to be released in App store (which disallows the simulator binary code in apps).

You can find the minimal example project that uses the binary framework in **UniversalFramework/Framework Example** subdirectory of the repository.

**Step 1.** Download the framework package from the release page:

Complete build: [FitAnalytics_WebWidget.framework-v0.4.2-all.tar.gz](https://github.com/UPcload/FitAnalytics-WebWidget-iOS/releases/download/v0.4.2/FitAnalytics_WebWidget.framework-v0.4.2-all.tar.gz)

Device-only build: [FitAnalytics_WebWidget.framework-v0.4.2-device_only.tar.gz](https://github.com/UPcload/FitAnalytics-WebWidget-iOS/releases/download/v0.4.2/FitAnalytics_WebWidget.framework-v0.4.2-device_only.tar.gz)

**Step 2.** Unpack the binary framework and add to the XCode project  via "Add files ..." context menu.

**Step 3.** When including header files (see below) add them in the form
```objc
#import <FitAnalytics_WebWidget/FITAWebWidget.h>
...
```
instead of 
```objc
#import "FITAWebWidget.h"
...
```
---

## Widget integration Procedure

We're presuming a simple app with the single main ViewController class.

Import the **FitAWebWidget.h** and the **FITAWebWidgetHandler.h** header file into your **ViewController.m**
 
```objc
#import "FITAWebWidget.h"
#import “FITAWebWidgetHandler.h"
```

The view controller class implements the **FITAWebWidgetHandler** interface, so that the widget callback can be implemented directly on it.

```objc
@interface ViewController ()<FITAWebWidgetHandler>
```

Add a property for storing the reference to the widget.

```objc
@property (nonatomic, strong) FITAWebWidget *widget;
```

Add a property for the WKWebView reference. This is the WKWebView instance that will contain the load widget container page.

```objc
@property (weak, nonatomic) IBOutlet WKWebView *wkWebView;
```

Initialize the widget controller with the WKWebView instance and assign self as the callback handler.

```objc
self.widget = [[FITAWebWidget alloc] initWithWKWebView:self.wkWebView handler:self];
```

<a name="wkwebview-warning"></a>__WARNING__

**Since iOS 12.x update, when using WKWebView, all widget interactions are reliable only when the widget container WebView is connected to the view hierarchy. When the WebView is in a disconnected state (i.e. it has no superview) all HTTP requests inside it begin to fail/timeout silently. To avoid this issue, always keep the WebView connected in the hierarchy and hide it visually (by setting the `hidden` property and the frame dimensions to zero). We are still looking into a better solution and/or workaround.**

## Methods

**`- (BOOL)load`**

Begin loading the HTML widget container page.

```objc
[self.widget load];
```

&nbsp;

**`- (BOOL)create:productSerial options:NSDictionary`**

Create and (optionally) initialize it with product serial and other options.

Create a widget instance inside the container page by passing the `productSerial` and `options`. Options can be `nil` or a dictionary of various options arguments. Important supported options are listed [here](#configurable-widget-options).

This method should be called only after the **WebWidgetDidBecomeReady** callback has been called (or inside the callback) and will return a `true` when the widget was successfully created.

```objc
[self.widget create:@"example-123456" options:@{ "sizes": @[ @"S", @"XL" ] }];
```

&nbsp;

**`- (void)open`**

Show the actual widget. It may trigger loading additional resources over network, and will show the widget only after all assets have been loaded. When the opening is finished, the **WebWidgetDidOpen** callback will be called on the callback handler.

```objc
[self.widget open];
```

&nbsp;

**`- (void)openWithOptions:productSerial options:NSDictionary`**

Configure the widget with new productSerial and/or options and show it. See `open` above for more details.

```objc
[self.widget open:@"example-123456" options:@{ "sizes": @[ @"S", @"XL" ] ];
```

&nbsp;

**`- (void) close`**

Close the widget and remove the widget markup. Will trigger the **webWidgetDidClose** callback when it finishes.

```objc
[self.widget close];
```

&nbsp;

**`- (void) recommend`**

Request a recommendation. The recommended size and additional details will be returned as arguments to the **WebWidgetDidRecommend** callback.

```objc
[self.widget recommend];
```

&nbsp;

**`- (void) recommendWithOptions:productSerial options:NSDictionary`**

Configure the widget with the new productSerial and/or widget options and request a recommendation. See `recommend` above for more details.

```objc
[self.widget recommend:@"example-123456" options:nil];
```

&nbsp;

**`- (void)reconfigure:productSerial options:NSDictionary`**

Configure the widget with the new productSerial and/or widget options. If the `productSerial` argument is non-nil and is different from the last provided product serial, this will trigger a request for the product information. After the new product info is loaded, the **webWidgetDidLoadProduct** will be called. If the product serial is invalid or the product isn't supported by Fit Analytics, the **webWidgetDidFailLoadingProduct** will be called.

```objc
[self.widget reconfigure:@"example-123456" options:nil];

// OR

[self.widget reconfigure:nil options:@{ "sizes": @[ @"XL" ] ];
```

Reconfigure the widget with a new product serial and/or widget options object.

## Callbacks

```objc
- (void)webWidgetDidBecomeReady:(FITAWebWidget *)widget;
```

This method will be called when widget container inside the WebView has successfully loaded and is ready to accept commands.

&nbsp;

```objc
- (void)webWidgetInitialized:(FITAWebWidget *)widget;
```

This method will be called when widget container inside the WebView has successfully loaded.

 * `widget` .. The widget controller instance

&nbsp;

```objc
- (void)webWidgetDidFailLoading:(FITAWebWidget *)widget withError:(NSError *)error;
```

This method will be called when widget inside the WebView has failed to load or initialize for some reason.

 * `widget` .. The widget controller instance
 * `error` .. The error instance

```objc
- (void)webWidgetDidLoadProduct:(FITAWebWidget *)widget productId:(NSString *)productId details:(NSDictionary *)details;
```

This method will be called when the widget has successfully loaded the product info. A successful load means that the product is supported by Fit Analytics and the widget should be able to provide a size recommendation for it.

 * `widget` .. The widget controller instance
 * `productId` .. The ID of the product
 * `details` .. The details object.

&nbsp;

```objc
- (void)webWidgetDidFailLoadingProduct:(FITAWebWidget *)widget productId:(NSString *)productId details:(NSDictionary *)details;
```

This method will be called when widget failed to load the product info or the product is not supported.

 * `widget` .. The widget controller instance
 * `productId` .. The ID of the product
 * `details` .. The details object.

&nbsp;

```objc
- (void)webWidgetDidOpen:(FITAWebWidget *)widget productId:(NSString *)productId;
```

This method will be called when the widget has successfully opened after the `open` method call.

 * `widget` .. The widget controller instance
 * `productId` .. The ID of the product

&nbsp;

```objc
- (void)webWidgetDidClose:(FITAWebWidget *)widget productId:(NSString *)productId size:(nullable NSString *)size details:(nullable NSDictionary *)details;
```

This method will be called when user of the widget has specifically requested closing of the widget by clicking on the close button.

 * `widget` .. The widget controller instance
 * `productId` .. The ID of the product
 * `size` .. The last recommended size of the product, if there was a recommendation. `null` if there wasn't any recommendation.
 * `details` .. The details object.

&nbsp;

```objc
- (void)webWidgetDidAddToCart:(FITAWebWidget *)widget productId:(NSString *)productId size:(nullable NSString *)size details:(nullable NSDictionary *)details;
```

This method will be called when user of the widget has specifically clicked on the add-to-cart inside the widget.

* `widget` .. The widget controller instance
* `productId` .. The ID of the product
* `size` .. The size of the product that should be added to cart.
* `details` .. The details object.

&nbsp;

```objc
- (void)webWidgetDidRecommend:(FITAWebWidget *)widget productId:(NSString *)productId size:(nullable NSString *)size details:(nullable NSDictionary *)details;
```

This method will be called after the `getRecommendation` call on the FITAWebWidget controller, when the widget has received and processed the size recommendation.
  
* `productId` .. The ID of the product
* `size` .. The recommended size of the product.
* `details` .. The details object.


## Configurable widget options

```ObjectiveC
@interface FitAnalyticsWidgetOptions : NSObject

/**
 *  (Shop Session ID) .. a first-party client generated session ID (can be a cookie): we use it to track purchases and keep our data more consistent (we **do NOT** use it to track or identify users)
 */
@property (nonatomic, strong) NSString *shopSessionId;

/**
 * The shop prefix, this is a value that we set internally so we can identify your shop with the product.
 */
@property (nonatomic, strong) NSString *shopPrefix;

/**
 * The product serial number, which is used to identify the product in the Fit Analytics database.
 * If `shopPrefix` is not set, we are going to infer the shop prefix based on the product serial number prefix. E.G. `shopprefix-abcd1234` (`<shop-prefix>-<product-id>`)
 */
@property (nonatomic, strong) NSString *productSerial;

/**
 * Product thumbnail image URL.
 */
@property (nonatomic, strong) NSString *thumb;

/**
 * All the sizes of your product, each size should be a key in the object, and the value should be a boolean indicating if the size is available or not.
 * They keys should match with the keys in the products' feed.
 * E.G. { M: true, L: false } means that the product is available in size M but not in size L.
 */
@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *> *manufacturedSizes;

/**
 * In stock sizes for the current product.
 * E.G. [{ value: "M", isAvailable: true }, { value: "L", isAvailable: false }]
 */
@property (nonatomic, strong) NSArray<NSDictionary<NSString *, NSNumber *> *> *sizes;

/**
 * The user identifier based on the shop's user id, for example in case the user is logged in.
 */
@property (nonatomic, strong) NSString *userId;

/**
 * ISO 639-1
 * E.G. "en"
 */
@property (nonatomic, strong) NSString *language;

/**
 * ISO 3166-1
 * E.G. "GB"
 */
@property (nonatomic, strong) NSString *shopCountry;

/**
 * Metric system
 * 0: imperial
 * 1: metric
 * 2: british
 * If it is not set it will be inferred from the shop country.
 */
@property (nonatomic) NSInteger metric;

- (void)closeWithProductSerial:(NSString *)productSerial size:(NSString *)size;
- (void)errorWithProductSerial:(NSString *)productSerial;
- (void)cartWithProductSerial:(NSString *)productSerial size:(NSString *)size;
- (void)recommendWithProductSerial:(NSString *)productSerial size:(NSString *)size;
- (void)loadWithProductSerial:(NSString *)productSerial;

@property (nonatomic, strong) NSString *userAge;

/**
 * m: man
 * w: women
 */
@property (nonatomic, strong) NSString *userGender;

/**
 * Even if the `metric` property is set to a different numerical system, the user's weight and height should be in kilograms and centimeters respectively.
 */
@property (nonatomic, strong) NSString *userWeight;
@property (nonatomic, strong) NSString *userHeight;

/**
 * Women bra measurements
 * The values described bellow can be obtained from the user's profile after they have filled in their bra measurements.
 * It is a large subset of possible bra measurements to be described, usually you feed the widget with the measurements available from the profile
 */
@property (nonatomic, strong) NSString *userBraBust;
@property (nonatomic, strong) NSString *userBraCup;
@property (nonatomic, strong) NSString *userBraSystem;

@end
```

---

## Purchase reporting

Purchase reporting usually means that when the user receives a confirmation of a successful purchases, namely, the user sees the Order Confirmation Page (a.k.a OCP or checkout page), the app will report all items in the order to Fit Analytics. The reporting is done by sending a simple HTTP request.

The usual report is a collection of attributes such as the order ID, the product serial for each purchased item, purchased size, price, currency, etc.

The most common attributes are:

* **orderId** .. (required) unique identifier of the order
* **userId** .. if the user is registered customer, their shop-specific ID
* **shopSessionId** (Shop Session ID) .. a first-party client generated session ID (can be a cookie): we use it to track purchases and keep our data more consistent (value **MUST** conform with the one passed in the PDP for the same shopping session)
* **productSerial** .. serial number/ID of the product (independent of purchased size!); it should match with the `productSerial` that was used for PDP size advisor.
* **shopArticleCode** .. (optional) the size-specific identifier
* **purchasedSize** .. the size code of the purchased size
* **shopCountry** .. if the shop has country-specific versions, specify it via this attribute
* **language** .. if your shop has language-specific versions, you can specify the language in which the purchase was made (which helps identify the user's sizing system)

For the complete list of possible reported fields and their description, please see https://developers.fitanalytics.com/documentation#sales-data-exchange

### Usage

Import the **FITAPurchaseReport.h** and the **FITAPurchaseReporter.h** header file.
 
```objc
#import "FITAPurchaseReport.h"
#import "FITAPurchaseReporter.h"
```

Create a new instance of the purchase reporter (**FITAPurchaseReporter**).

```objc
FITAPurchaseReporter *reporter = [[FITAPurchaseReporter alloc] init];
```

For each line item present in the customer's order, create a new instance of **FITAPurchaseReport** and send it via reporter.

```objc
FITAPurchaseReport *report = [[FITAPurchaseReport alloc] init];

report.orderId = @"0034";
report.userId = @"003242A32A";
report.productSerial = @"test-55322214";
report.purchasedSize = @"XXL";

report.shopSessionId = @"0a1b2c3d"
// add additional attributes, such as shopCountry, lanugage etc. here.

[reporter sendReport:report];
```

Alternatively, you can initialize the report instance with a dictionary. That can be useful for setting shared defaults, for example.

```objc

NSDictionary *reportDefaults = @{
  @"orderId": @"0034",
  @"userId": @"003242A32A"
};

FITAPurchaseReport *report = [[FITAPurchaseReport alloc] initWithDictionary:reportDefaults];

report.productSerial = @"test-55322214";
report.purchasedSize = @"XXL";

[reporter sendReport:report];
```

If you wish to wait until reporting has finished, you can pass a callback function.

```objc
[reporter sendReport:report done:^(NSError *error) {
  if (error != nil)
    NSLog("ERROR: %@", error);
  else
    NSLog("SUCCESS");
}]
```

