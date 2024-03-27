Pod::Spec.new do |s|
  s.name             = 'FitAnalytics-WebWidget'
  s.version          = '0.5.3'
  s.summary          = 'FitAnalytics WebWidget SDK for iOS'
  s.author           = 'FitAnalytics'
  s.homepage         = 'https://www.fitanalytics.com/'
  s.source           = {
    git: 'https://github.com/UPcload/FitAnalytics-WebWidget-iOS.git',
    tag: s.version,
    submodules: false
  }
  s.license          = { type: 'MIT', file: 'LICENSE.md' }

  s.platform         = :ios, '11.0'
  s.requires_arc     = true

  s.framework        = 'UIKit'
  s.source_files     = 'FitAnalytics-WebWidget/*.{h,m,mm}'
  s.resource_bundles = {"FitAnalytics-WebWidget" => ["FitAnalytics-WebWidget/PrivacyInfo.xcprivacy"]}
end
