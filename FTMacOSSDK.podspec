
Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "FTMacOSSDK"
  spec.version      = "0.0.1"
  spec.summary      = "DataFlux MacOS SDK"
  spec.description  = "DataFlux MacOS SDK"

  spec.homepage     = "http://EXAMPLE/FTMacOSSDK"

  spec.license      = { type: 'Apache', :file => 'LICENSE'}


  spec.author             = { "hulilei" => "hulilei@jiagouyun.com" }
 
  spec.osx.deployment_target = '10.10'
  spec.requires_arc = true
  
  spec.source       = { :git => "http://EXAMPLE/FTMacOSSDK.git", :tag => "#{spec.version}" }

  spec.default_subspec = "SDKCore"

  spec.subspec 'SDKCore' do |core|
       core.source_files  = "FTMacOSSDK/SDKCore/*.{h,m}"
       core.dependency = "FTMacOSSDK/AutoTrack"
       core.dependency 'FTMacOSSDK/Common'

  end

  spec.subspec 'Common' = |c|
       c.source_files ="FTMacOSSDK/BaseUtils/*.{h,m}"
  end
  
  spec.subspec 'AutoTrack' = 'autotracker'
        autotracker.source_files = "FTMacOSSDK/AutoTrack/*.{h,m}"
  end
  
end
