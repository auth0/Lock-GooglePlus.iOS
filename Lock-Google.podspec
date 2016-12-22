version = `agvtool mvers -terse1`.strip
Pod::Spec.new do |s|
  s.name             = "Lock-Google"
  s.version          = version
  s.summary          = "Google Native Integration for Auth0 Lock"
  s.description      = <<-DESC
                      [![Auth0](https://i.cloudup.com/1vaSVATKTL.png)](http://auth0.com)
                      Plugin for [Auth0 Lock](https://github.com/auth0/Lock.iOS-OSX) that handles authentication using Google iOS SDK.
                      > This plugin replaces the deprecated `Lock-GooglePlus` plugin
                       DESC
  s.homepage         = "https://github.com/auth0/Lock-Google.iOS"
  s.license          = 'MIT'
  s.author           = { "Auth0" => "support@auth0.com", "Hernan Zalazar" => "hernan@auth0.com" }
  s.source           = { :git => "https://github.com/auth0/Lock-Google.iOS.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/auth0'

  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.module_name = 'LockGoogle'

  s.public_header_files = ['LockGoogle/A0GoogleAuthenticator.h', 'LockGoogle/LockGoogle.h']
  s.private_header_files = 'LockGoogle/A0GoogleProvider.h'
  s.source_files = 'LockGoogle/*.{h,m}'

  s.dependency 'Google/SignIn', '~> 3.0.0'
  s.dependency 'Lock/Core', '~> 1.26'
end
