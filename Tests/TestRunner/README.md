Build and run all tests from command line:

```

$ xcodebuild \
  -workspace TestRunner.xcworkspace \
  -scheme TestRunner \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone SE,OS=11.1' \
  test | xcpretty --color

```

Build and a single group of tests (ReporterTests):

```

$ xcodebuild \
  -workspace TestRunner.xcworkspace \
  -scheme TestRunner \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone SE,OS=11.1' \
  -only-testing:ReporterTests \
  test | xcpretty --color

```

