Pod::Spec.new do |s|
  s.name             = 'Streamline'
  s.version          = '1.0.0'
  s.summary          = 'Framework Swift module networking fast.'
  s.description      = <<-DESC
Streamline is a modular Swift networking framework designed for flexibility, speed, and ease of integration.
It provides built-in support for HTTP requests, WebSockets, JWT authentication, request interceptors, MTLS certificates, and more.
  DESC
  s.homepage         = 'https://github.com/ziminny/Streamline'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Vagner Reis' => 'ziminny@gmail.com' }
  s.source           = { :git => 'https://github.com/ziminny/Streamline.git', :tag => s.version.to_s }
  s.ios.deployment_target = '14.0'
  s.macos.deployment_target = '11.0'
  s.source_files     = 'Sources/**/*.{swift,h}'
  s.swift_versions   = ['5.9', '6.0']
  s.dependency 'Socket.IO-Client-Swift', '~> 16.1.0'
end
