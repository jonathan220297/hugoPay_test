Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '11.0'
s.name = "hugoPay"
s.summary = "hugoPay es la plataforma fintech más revolucionaria en Centroamerica"
s.requires_arc = true

# 2
s.version = "0.0.1"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Jonathan Rodríguez" => "jonathan.rodriguez@hugoapp.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/jonathan220297/hugoPay_test"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/jonathan220297/hugoPay_test.git",
             :tag => "#{s.version}" }

# 7
s.framework = "UIKit"
s.dependency 'Firebase/Auth'
s.dependency 'Firebase/Core'
s.dependency 'HugoCommons', '1.12.1'
s.dependency 'HugoFun', '1.11.3'
s.dependency 'HugoNetworking', '0.6.1'
s.dependency 'CryptoSwift'
s.dependency 'Malert'
s.dependency 'Nuke', '~> 7.0'
s.dependency 'Parse', '1.19.0'
s.dependency 'R.swift'
s.dependency 'RxSwift'
s.dependency 'RxCocoa'
s.dependency 'SimpleAlert'
s.dependency 'SnapKit'
s.dependency 'SwiftKeychainWrapper'
s.dependency 'SwiftLuhn'
s.dependency 'VGSCollectSDK'
s.dependency 'XCGLogger'

# 8
s.source_files = "hugoPay/**/*.{swift}"

# 9
s.resources = "hugoPay/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# 10
s.swift_version = "5.0"

end
