#
# Be sure to run `pod lib lint NNCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NNCore'
  s.version          = '0.0.1'
  s.summary          = 'A short description of NNCore.'
  s.homepage         = 'https://github.com/ws00801526/NNCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'XMFraker' => '3057600441@qq.com' }
  s.source           = { :git => 'https://github.com/ws00801526/NNCore.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.default_subspecs = 'Core'

  s.subspec 'Core' do |ss|
      ss.source_files = 'NNCore/Classes/**/*'
      ss.public_header_files = 'NNCore/Classes/**/*.h'
      #集成初始化模块
      ss.dependency 'BeeHive'
      #集成日志输出模块, 统一日志输出
      ss.dependency 'CocoaLumberjack'
      #默认集成YYModel模块
      ss.dependency 'YYModel'
  end

  s.subspec 'Nav' do |ss|
      ss.dependency 'NNCore/Core'
      ss.source_files = 'NNNav/Classes/**/*'
      ss.public_header_files = 'NNNav/Classes/**/*.h'
  end
end
