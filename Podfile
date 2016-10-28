source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!
target 'DoubanMovie' do

pod 'SDWebImage', '~> 4.0.0-beta2'
pod 'AFNetworking', '~> 3.1.0'
#pod 'Realm', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
#pod 'RealmSwift', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
pod 'ObjectMapper', '~> 2.1.0'
pod 'AWPercentDrivenInteractiveTransition', '~> 0.2.0'
pod 'RxAlamofire', '~> 3.0.0-rc.1'
pod 'RxCocoa', '~> 3.0.0-rc.1'
end
post_install do |installer|
    installer.pods_project.targets.each do |target|	
        target.build_configurations.each do |config|
	    config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
