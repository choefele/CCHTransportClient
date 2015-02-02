Pod::Spec.new do |spec|
  spec.name     = 'CCHTransportClient'
  spec.version  = '1.0'
  spec.license  = 'Copyright Claus Höfele'
  spec.summary  = 'Objective-C implementation of various transportation APIs.'
  spec.homepage = 'https://github.com/optionu/CCHTransportClient'
  spec.authors  = { 'Claus Höfele' => 'claus@claushoefele.com' }
  spec.social_media_url = 'https://twitter.com/claushoefele'
  spec.source   = { :git => 'https://github.com/optionu/CCHTransportClient.git', :tag => spec.version.to_s }
  spec.frameworks = 'CoreLocation'
  spec.requires_arc = true

  spec.dependency 'Ono', '~> 1.1.3'
  spec.dependency 'CCHBinaryData', '~> 1.0.0'
  spec.dependency 'GZIP', '~> 1.0.3'

  spec.ios.deployment_target = '7.0'
  spec.osx.deployment_target = '10.9'

  spec.source_files = 'CCHTransportClient/**/*.{h,m}'
end
