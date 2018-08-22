#
# Be sure to run `pod lib lint ClickableImage.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ClickableImage'
  s.version          = '1.0.0'
  s.summary          = 'ClickableImage is a extension that users to tap image views to expand them.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ClickableImage is an extension written in Swift for iOS that allows UIImageView's to be expanded to be made tappable by the user to expand the image full screen and allow them to pinch to zoom, and swipe the image away to dismiss.
                       DESC

  s.homepage         = 'https://github.com/rrainn/ClickableImage'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rrainn' => 'support@rrainn.com' }
  s.source           = { :git => 'https://github.com/rrainn/ClickableImage.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/rrainn_inc'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ClickableImage/Classes/**/*'

  s.frameworks = 'UIKit'
  
  s.swift_version = '4.2'
end
