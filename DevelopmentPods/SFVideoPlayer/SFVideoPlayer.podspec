Pod::Spec.new do |s|
  s.name             = 'SFVideoPlayer'
  s.version          = '0.0.1'
  s.summary          = 'Simple video player'

  s.description      = <<-DESC
                        Video Player
                       DESC

  s.homepage         = 'https://github.com/alexiscn/WeChatSwift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'alexiscn' => 'shuifengxu@gmail.com' }
  s.source           = { :git => 'https://github.com/alexiscn/WeChatSwift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.10'
  s.source_files = '**/*'
  s.dependency 'Alamofire'
end
