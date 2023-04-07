
Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "FTMacOSSDK"
  spec.module_name  = "FTMacOSSDK"
  spec.version      = "0.0.1-alpha.1"
  spec.summary      = "DataFlux MacOS SDK"
  spec.description  = "DataFlux MacOS SDK"

  spec.homepage     = "http://gitlab.jiagouyun.com/cma/ft-sdk-macos"

  spec.license      = { type: 'Apache', :file => 'LICENSE'}


  spec.author             = { "hulilei" => "hulilei@jiagouyun.com" }
 
  spec.osx.deployment_target = '10.10'
  spec.requires_arc = true
  
  spec.source       = { :git => "http://gitlab.jiagouyun.com/cma/ft-sdk-macos.git", :tag => "#{spec.version}" }

  spec.default_subspec = "SDKCore"

  spec.subspec 'SDKCore' do |core|
       core.source_files  = "FTMacOSSDK/SDKCore/**/*.{h,m}"
       core.dependency 'FTMobileSDK', '1.3.12-alpha.2'

  end

  
  
end
