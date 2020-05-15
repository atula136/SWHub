source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

target 'SWHub' do
	pod 'SWFrame', :path => '../SWFrame'
	# pod 'SWFrame', '1.1.0'
  
	# 界面
	pod 'IQKeyboardManagerSwift', '6.5.5'
	pod 'ReusableKit/RxSwift', '3.0.0'
	pod 'Parchment', '2.3.0'
	pod 'Highlightr', '2.1.0'
	pod 'MarkdownView', '1.5.0'
	
	# 网络
	# pod 'Kingfisher', '4.10.1'
	
	# 响应
	pod 'RxOptional', '4.0.0'
	pod 'RxGesture', '3.0.0'
		
	# 资源
	pod 'RxTheme', '4.0.0'
	pod 'Iconic', '1.5'
	pod 'R.swift', '5.1.0'
		
	# 工具
	pod 'SwiftLint', '0.39.2'
	pod 'FLEX', '3.0.0'
	pod 'MLeaksFinder', '1.0.0'
		
	# 平台
	
	# pod 'CocoaLumberjack/Swift', '3.5.3'
	# pod 'ReachabilitySwift', '5.0.0-beta1'
	# pod 'Kingfisher', '4.10.1'
	# pod 'RxOptional', '4.0.0'
	# pod 'RxGesture', '3.0.0'
	# pod 'RxDataSources', '4.0.1'
	# pod 'FSPagerView', '0.8.2'
	# pod 'LGButton', '1.1.6'
	# pod 'DZNEmptyDataSet', '1.8.1'
	# pod 'ReusableKit/RxSwift', '3.0.0'
	# pod 'KeychainAccess', '3.2.0'
	# pod 'FCUUID', '1.3.1'
	# pod 'FLEX', '3.0.0'
	# pod 'MLeaksFinder', '1.0.0'
	# pod 'AlibcTradeSDK', '4.0.0.0'
	# pod 'AliAuthSDK', '2.0.0.0'
	# pod 'mtopSDK', '3.0.0.4'
	# pod 'securityGuard', '5.4.172'
	# pod 'AliLinkPartnerSDK', '2.0.0.0'
	# pod 'BCUserTrack', '5.2.0.1-appkeys'
	# pod 'UTDID', '1.1.0.16'
	# pod 'AlipaySDK', '2.0.0-bc'
  
  # 基础库
  # pod 'NSObject+Rx', '5.0.0'
  # pod 'RxViewController', '1.0.0'
  # pod 'CGFloatLiteral', '0.5.0'
  # pod 'SwifterSwift', '5.1.0-jx1'
  # pod 'URLNavigator', '2.2.0-jx6'
  # pod 'QMUIKit', '4.0.3'
  # pod 'Cache', '5.2.0'
  # 布局库
  # pod 'SnapKit', '4.2.0'
  # pod 'ManualLayout', '1.3.0'
  
  # 网络库
  
  # 响应库
  # pod 'ReactorKit', '2.0.1'
  
  # 界面库
  
  # 资源库
  
  # 组合库
  # pod 'Moya-ObjectMapper/RxSwift', '2.8-jx2'
  
  # 工具库
  # pod 'BonMot', '5.4.1'
  
  # 开放库
  
  # 未采用
  # pod 'ESPullToRefresh', '2.9'
  # pod 'KafkaRefresh', '1.4.7'
  # pod 'DropDown', '2.3.13'
  # pod 'Iconic', '1.3'
  # pod 'SwiftIconFont', '3.0.0'
  # pod 'SwiftDate', '6.0.3'
  # pod 'QueryKit', '0.13.0'
  # pod 'FDFullscreenPopGesture', '1.1'
  # pod 'Then', '2.5.0'
  # pod 'NVActivityIndicatorView', '4.7.0'
  # pod 'DZNEmptyDataSet', '1.8.1'
  # pod 'SwiftyJSON', '5.0.0'
  # pod 'NSObject+Rx', '5.0.0'
  # pod 'RxCocoa', '5.0.0'
  # pod 'RxCocoa', '5.0.0'
  # pod 'Moya/RxSwift', '14.0.0-alpha.1'
  # pod 'ObjectMapper', '3.5.1'
  # pod 'RAMAnimatedTabBarController', '5.0.1'
  # pod 'Hero', '1.4.0'
  # pod 'Localize-Swift', '2.0.0'
  # pod 'Umbrella/Core', '0.9.0'
  
end

post_install do |installer|
    # Enable tracing resources
    installer.pods_project.targets.each do |target|
      if target.name == 'RxSwift'
        target.build_configurations.each do |config|
          if config.name == 'Debug'
            config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
          end
        end
      end
      if ['Iconic'].include?(target.name)
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '4.2'
      end
    end
  end
end
