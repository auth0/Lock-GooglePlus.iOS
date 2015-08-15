Pod::Spec.new do |s|
  s.name             = "Lock-GooglePlus"
  s.version          = "1.0.1"
  s.summary          = "Google+ Native Integration for Auth0 Lock"
  s.description      = <<-DESC
                      [![Auth0](https://i.cloudup.com/1vaSVATKTL.png)](http://auth0.com)
                      Plugin for [Auth0 Lock](https://github.com/auth0/Lock.iOS-OSX) that handles authentication using Google+ iOS SDK.
                       DESC
  s.homepage         = "https://github.com/auth0/Lock-Google.iOS"
  s.license          = 'MIT'
  s.author           = { "Auth0" => "support@auth0.com", "Hernan Zalazar" => "hernan@auth0.com" }
  s.source           = { :git => "https://github.com/auth0/Lock-Google.iOS.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/auth0'

  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.module_name = 'LockGooglePlus'

  s.public_header_files = 'Pod/Classes/*.h'
  s.source_files = 'Pod/Classes/*.{h,m}'

  s.dependency 'googleplus-ios-sdk', '~> 1.7.1'
  s.dependency 'Lock/Core', '~> 1.11'
  s.deprecated = true
end