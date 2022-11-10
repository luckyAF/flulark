#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flulark.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flulark'
  s.version          = '0.0.1'
  s.summary          = 'flutter飞书登录'
  s.description      = <<-DESC
flutter飞书登录
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'luckyAF' => 'luckyAF@github.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'LarkSSO', '~> 1.1.6'
  s.platform = :ios, '9.0'
  s.swift_version = '5.7'
  s.static_framework = true
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.user_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }
end
