use_frameworks!

def core_pods
  pod 'GoogleSignIn', '~> 4.0'
  pod 'Google/SignIn'
  pod 'Lock/Core', '~> 1.28', :inhibit_warnings => true
  pod 'ISO8601DateFormatter', :inhibit_warnings => true
  pod 'CocoaLumberjack', :inhibit_warnings => true
end

target 'LockGoogleApp' do
  core_pods
end

target 'LockGoogle' do
  core_pods
end

target 'LockGoogleTests' do
  pod 'Specta', :inhibit_warnings => true
  pod 'Expecta', :inhibit_warnings => true
  pod 'OCMockito', '~> 2.0', :inhibit_warnings => true
  pod 'OCHamcrest', :inhibit_warnings => true
end
