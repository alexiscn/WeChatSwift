Pod::Spec.new do |s|
  s.name         = 'WCNavigationBar'
  s.version      = '0.0.1'
  s.license = 'MIT'
  s.requires_arc = true
  s.source = { :git => 'https://github.com/alexiscn/WCNavigationBar.git', :tag => s.version.to_s }

  s.summary         = 'WCNavigationBar'
  s.homepage        = 'https://github.com/alexiscn/WCNavigationBar'
  s.license         = { :type => 'MIT' }
  s.author          = { 'xushuifeng' => 'shuifengxu@gmail.com' }
  s.platform        = :ios
  s.swift_version   = '5.0'
  s.source_files    =  '**/*.{swift}'
  s.ios.deployment_target = '11.0'
  
end

