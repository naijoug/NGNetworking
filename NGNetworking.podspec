Pod::Spec.new do |s|

  s.name                = "NGNetworking"
  s.version             = "0.2.1"
  s.summary             = "A DIY network lib by AFNetworking."
  s.description         = <<-DESC
        A DIY network lib by AFNetworking !!!
                          DESC
  s.homepage            = "https://github.com/naijoug/NGNetworking"
  s.license             = "MIT"
  s.author              = { "naijoug" => "naijoug@126.com" }
  s.platform            = :ios, "8.0"

  s.source              = { :git => "https://github.com/naijoug/NGNetworking.git", :tag => "#{s.version}" }
  
  s.public_header_files = "NGNetworking/**/*.h"
  s.source_files        = "NGNetworking/**/*.{h,m}"
  s.framework           = "Foundation"
  s.requires_arc        = true
  s.dependency "AFNetworking", "~> 3.0.0"
  s.dependency "YYModel", "~> 1.0.4"

end
