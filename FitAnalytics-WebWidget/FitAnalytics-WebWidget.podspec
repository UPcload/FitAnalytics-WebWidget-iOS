Pod::Spec.new do |s|
  s.name             = 'FitAnalytics-WebWidget'
  s.version          = '0.2.0'
  s.summary          = 'FitAnalytics WebWidget SDK for iOS'
  s.author           = 'FitAnalytics'
  s.homepage         = 'https://www.fitanalytics.com/'
  s.source           = {
    git: 'https://github.com/UPcload/FitAnalytics-WebWidget-iOS.git',
    tag: s.version,
    submodules: false
  }
  s.license          = { type: 'MIT', file: '../LICENSE.md' }

  s.platform         = :ios, '9.0'
  s.requires_arc     = true

  s.framework        = 'UIKit'
  s.source_files     = '*.{h,m,mm}'
end
