Pod::Spec.new do |s|

  s.name         = "PNChart"
  s.version      = "0.7.5.2"
  s.summary      = "A simple and beautiful chart lib with animation used in Piner for iOS"
  s.homepage     = "https://github.com/kevinzhow/PNChart"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "kevinzhow" => "kevinchou.c@gmail.com" }
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/teambox/PNChart.git", :tag => "0.7.5.2" }
  s.source_files  = "PNChart", "PNChart/**/*.{h,m}"
  s.public_header_files = "PNChart/**/*.h"
  s.frameworks   = 'CoreGraphics', 'UIKit', 'Foundation', 'QuartzCore'
  s.requires_arc = true
  s.dependency 'UICountingLabel', '~> 1.0.0'

end
