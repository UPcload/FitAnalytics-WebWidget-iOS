
## Universal framework builder

Builds **FitAnalytics-WebWidget** library as the universal framework. To build release files, (1) open the `Project` folder in XCode; (2) select **UniversalBuilder** target and hit **Build**. It will create two binary release archives:

1. `Builds/all/FitAnalytics_WebWidget.framework-all.tar.gz` .. includes binary versions for devices (arm7, arm7s, arm64) and for iphone-simulator (i386, x86_64). Intended for general development, as it supports running in the simulator and on the device
2. `Builds/device_only/FitAnalytics_WebWidget.framework-device_only.tar.gz` .. includes binary versions for devices only (arm7, arm7s, arm64). Intended for device-only development and for App Store releases (which do not allow simulator binary code).
