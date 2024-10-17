# TestRunner

## Pre-requisites
Install (xcpretty)[https://github.com/xcpretty/xcpretty]


Build and run all tests from command line:

```

$ xcodebuild \
  -workspace TestRunner.xcworkspace \
  -scheme TestRunner \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.4' \
  test | xcpretty --color

```

Build and a single group of tests (ReporterTests):

```

$ xcodebuild \
  -workspace TestRunner.xcworkspace \
  -scheme TestRunner \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.4' \
  -only-testing:ReporterTests \
  test | xcpretty --color

```
