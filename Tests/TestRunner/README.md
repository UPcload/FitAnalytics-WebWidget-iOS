
### Running tests

Build and run all tests from command line:

```bash

$ xcodebuild \
  -workspace TestRunner.xcworkspace \
  -scheme TestRunner \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone SE,OS=11.1' \
  test | xcpretty --color

```

Build and a single group of tests (ReporterTests):

```bash

$ xcodebuild \
  -workspace TestRunner.xcworkspace \
  -scheme TestRunner \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone SE,OS=11.1' \
  -only-testing:ReporterTests \
  test | xcpretty --color

```

To use UIWebView for tests instead of WKWebView, add  `com.fitanalytics.useUIWebView` to app launch arguments.

### Running network failure tests

There are few additional tests in WebWidgetTests that are not run by default because they require additional setup. They have a name with suffix "...WithNetworkError", Both are simulating a network failure (specifically the TCP reset) at some point of widget integration. The simulation uses a special service that controls the local firewall, in order to simulate the network failure.

To run these two tests, you'll need to:

1) Run the **nethooks** service. This a simple HTTP service that allows control of the MacOS `pf` firewall.

```bash
$ cd Tests/nethooks
$ npm install
$ npm start
#  .. you will be asked for sudo password 
```

2) Define the `NETHOOKS_HOST` in the product scheme. In Xcode go to Product > Scheme > Edit scheme... and add the variable `NETHOOKS_HOST` with value `http://127.0.0.1:7034`

When the `NETHOOKS_HOST` variable isn't defined these tests will pass automatically, but won't do any real testing.
