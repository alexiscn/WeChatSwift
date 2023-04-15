platform:ios, '13.0'
use_frameworks!

target 'WeChatSwift' do
  
  pod 'WXNavigationBar'
  pod 'WXActionSheet'
  pod 'WXGrowingTextView'
  pod 'MMKV'
  pod 'WCDB.swift'
  pod 'Texture'
  pod 'SSZipArchive'
  pod 'PINRemoteImage'
    
  pod 'FLEX', :configurations => ['Debug']
    
  pod 'SVGKit', :path => 'DevelopmentPods/SVGKit'
  pod 'SFVideoPlayer', :path => 'DevelopmentPods/SFVideoPlayer'
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end
